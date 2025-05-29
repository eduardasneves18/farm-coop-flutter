part of 'cliente_store.dart';

mixin _$ClienteStore on _ClienteStore, Store {
  late final _$clienteAtom =
      Atom(name: '_ClienteStore.cliente', context: context);

  @override
  Cliente get cliente {
    _$clienteAtom.reportRead();
    return super.cliente;
  }

  @override
  set cliente(Cliente value) {
    _$clienteAtom.reportWrite(value, super.cliente, () {
      super.cliente = value;
    });
  }

  late final _$_ClienteStoreActionController =
      ActionController(name: '_ClienteStore', context: context);

  @override
  dynamic defineCliente(Cliente value) {
    final _$actionInfo = _$_ClienteStoreActionController.startAction(
        name: '_ClienteStore.defineCliente');
    try {
      return super.defineCliente(value);
    } finally {
      _$_ClienteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeCliente() {
    final _$actionInfo = _$_ClienteStoreActionController.startAction(
        name: '_ClienteStore.removeCliente');
    try {
      return super.removeCliente();
    } finally {
      _$_ClienteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cliente: ${cliente}
    ''';
  }
}
