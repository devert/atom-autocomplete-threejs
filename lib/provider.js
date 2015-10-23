'use babel';

import { filter as fuzzaldrin } from 'fuzzaldrin';
// import yaml from 'js-yaml';
import fs from 'fs';
import path from 'path';
import espree from 'espree';
import estraverse from 'estraverse';

export default class Provider {

  constructor () {
    this.selector = '.source.js';
    this.disableForSelector = '.source.js .comment, .source.js .string';
    this.filterSuggestions = true;
    this.inclusionPriority = 9;
    this.excludeLowerPriority = false;

    this.globalFunction = 'THREE.';
    this.completions = [];
  }

  loadCompletions () {
    var threejs = fs.readFileSync(path.resolve(__dirname, '../node_modules/three.js/build/', 'three.js'), 'utf8');
    var ast = espree.parse(threejs);

    estraverse.traverse(ast, {
      enter: function (node) {
      }
    });
  }

  // loadCompletions () {
  //   var reference = yaml.safeLoad(fs.readFileSync(path.resolve(__dirname, '..', 'completions.yaml'), 'utf8'));
  //   var classCollection = reference.classes;
  //
  //   for (var name of Object.keys(classCollection)) {
  //     let obj = {};
  //     let refObj = classCollection[name];
  //     obj.type = 'class';
  //     if (refObj.hasOwnProperty('constructor')) {
  //       obj.snippet = name + '(';
  //       refObj.constructor.forEach(function (argument, i) {
  //         if (i > 0) {
  //           obj.snippet += ', ';
  //         }
  //         obj.snippet += '${' + (i+1) + ':'+ argument +'}';
  //       });
  //       obj.snippet += ')${0}';
  //     }
  //     obj.text = name;
  //     obj.description = refObj.description;
  //     obj.descriptionMoreURL = refObj.descriptionMoreURL;
  //     obj.leftLabel = 'THREE';
  //     obj.rightLabel = 'Constructor';
  //     obj.displayText = name;
  //     this.completions.push(obj);
  //   }
  // }

  getPrefix (editor, bufferPosition) {
    const line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition]);
    const index = line.lastIndexOf(this.globalFunction);

    return index === -1
      ? ''
      : line.slice(index);
  }

  getSuggestions ({editor, bufferPosition}) {
    const prefix = this.getPrefix(editor, bufferPosition);
    if (!prefix) return [];

    const matches = fuzzaldrin(this.completions, prefix.replace(this.globalFunction, ''), { key: 'text' });
    if (!matches.length) return [];

    for (var match in matches) {
      match.replacementPrefix = prefix;
    }

    return matches;
  }

}
