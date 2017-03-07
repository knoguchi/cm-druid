#!/usr/bin/env python
from __future__ import print_function, absolute_import, division
import json
import sys
import re
import xml.etree.cElementTree as ET

from collections import defaultdict
from warnings import warn
from argparse import ArgumentParser

param_pattern = re.compile(r'\$\{(.*?)\}')


def read_properties(path, interpolate=True):
    props = {}
    with open(path, 'r') as f:
        for row in f:
            row = row.strip()
            if not row:
                continue
            k, v = row.split('=', 1)
            k = k.strip().decode('utf-8')
            v = v.strip().decode('utf-8')
            if interpolate:
                param_keys = param_pattern.findall(v)
                for param_key in param_keys:
                    assert param_key in props
                    v = v.replace("${{{0}}}".format(param_key), props[param_key])
            props[k] = v
    return props

def preprocess(v1props):
    _types = {
        "org.apache.log4j.ConsoleAppender": "Console",
        "org.apache.log4j.DailyRollingFileAppender": "DailyRollingFile",
        "org.apache.log4j.RollingFileAppender": 'RollingFile'
    }
    appenders = defaultdict(dict)
    loggers = defaultdict(dict)
    additivities = defaultdict(dict)

    for key, value in v1props.items():
        if key.startswith('log4j.appender.'):
            l = key.split('.')
            l += [None] * (5 - len(l))  # padding
            _, appender, name, property_, extra = l
            if property_:
                appenders[name][property_] = value
            else:
                appenders[name]['type'] = _types[value]

            if extra:
                value = value.replace('ISO8601', 'DEFAULT')
                appenders[name]['pattern'] = value
                
        elif key.startswith('log4j.logger.'):
            name = key[len('log4j.logger.'):]
            loggers[name] = [s.strip() for s in value.split(',')]
        elif key.startswith('log4j.category.'):
            name = key[len('log4j.category.'):]
            loggers[name] = [s.strip() for s in value.split(',')]
        elif key.startswith('log4j.additivity.'):
            name = key[len('log4j.additivitiy.'):]
            additivities[name] = [s.strip() for s in value.split(',')]
        elif key.startswith('log4j.rootCategory') or key.startswith('log4j.rootLogger'):
            root_categories = [s.strip() for s in value.split(',')]
            root_level = root_categories[0]
            root_appenders = root_categories[1:] if len(root_categories) > 1 else []
        #else:
        #    warn("unknown property {key} ignored!".format(key=key))

    return dict(rootLevel=root_level, rootAppenders=root_appenders,
                appenders=dict(appenders),
                loggers=dict(loggers),
                additivities=dict(additivities))
    
def generate(bindings):
    configuration = ET.Element('Configuration')
    appenders = ET.SubElement(configuration, "Appenders")
    for name, values in bindings['appenders'].items():
        if values['type'] == 'Console':
            console = ET.SubElement(appenders, "Console", name=name, target='SYSTEM_ERR')
            pattern_layout= ET.SubElement(console, "PatternLayout", pattern=values['pattern'])
        elif values['type'] == 'DailyRollingFile':
            rolling_file = ET.SubElement(appenders, 'RollingFile', name=name, fileName=values['File'],
                                         filePattern="{0}-%d{{{1}}}".format(values['File'], values['DatePattern']))
            pattern_layout= ET.SubElement(rolling_file, "PatternLayout", pattern=values['pattern'])
            policy = ET.SubElement(rolling_file, "TimeBasedTriggeringPolicy")
        elif values['type'] == 'RollingFile':
            rolling_file = ET.SubElement(appenders, 'RollingFile', name=name, fileName=values['File'],
                                         filePattern="{0}.%i".format(values['File']))
            pattern_layout= ET.SubElement(rolling_file, "PatternLayout", pattern=values['pattern'])
            policies = ET.SubElement(rolling_file, "Policies")
            policy1 = ET.SubElement(policies, "SizeBasedTriggeringPolicy", size=values['MaxFileSize'])
            strategy = ET.SubElement(rolling_file, "DefaultRolloverStrategy", max=values['MaxBackupIndex'])

    loggers = ET.SubElement(configuration, "Loggers")
    for name, values in bindings['loggers'].items():
        async_logger = ET.SubElement(loggers, "AsyncLogger", name=name, level=values[0].strip(), additivity=additivities.get(name, 'false'))
        if len(values) > 1:
            logger_appenders = values[1:]
            for it in logger_appenders:
                ET.SubElement(async_logger, 'AppenderRef', ref=it.strip())
                
    async_root = ET.SubElement(loggers, 'AsyncRoot', level=bindings['rootLevel'])
    for name in bindings['rootAppenders']:
        ET.SubElement(async_root, 'AppenderRef', ref=name.strip())
        
            
    tree = ET.ElementTree(configuration)
    return ET.tostring(tree.getroot(), encoding='utf8')

def main(args):
    v1props = read_properties(args.input_file, args.interpolate)
    if args.debug:
        print(json.dumps(v1props, indent=2, sort_keys=True), file=sys.stderr)
    v2xml = generate(preprocess(v1props))

    if args.output_file:
        with open(args.output_file, 'w') as f:
            f.write(v2xml)
    else:
        print(v2xml)
    

if __name__ == '__main__':
    parser = ArgumentParser(description='log4j2-migrator')

    # positional arguments
    parser.add_argument('input_file', metavar='input_file', type=str, help='log4j properties file path')

    # optional arguments
    parser.add_argument('-o', '--output', dest="output_file", action='store', type=str, help='file to write the output')
    parser.add_argument('-d', '--debug', dest="debug", action='store_true', help='print debug information')
    parser.add_argument('-i', '--interpolate', action='store_true', dest='interpolate', 
                        help='substitute parameters')

    args = parser.parse_args()
    
    main(args)
