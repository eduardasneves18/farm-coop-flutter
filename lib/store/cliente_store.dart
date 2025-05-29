import 'package:mobx/mobx.dart';
import '../models/cliente.dart';

part 'cliente_store.g.dart';

class ClienteStore = _ClienteStore with _$ClienteStore;

abstract class _ClienteStore with Store {
  @observable
  Cliente cliente = Cliente();

  @action
  defineCliente(Cliente value) {
    cliente = value;
  }

  @action
  removeCliente() {
    cliente = Cliente();
  }
}
