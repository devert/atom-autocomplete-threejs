'use babel';

import Provider from './provider';

var provider = new Provider();

export function activate () {
  provider.loadCompletions();
}

export function getProvider () {
  return provider;
}
