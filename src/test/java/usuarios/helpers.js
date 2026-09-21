function fn() {
  var timestamp = java.lang.System.currentTimeMillis();
  return {
    nome: 'Usuario Test ' + timestamp,
    email: 'user' + timestamp + '@test.com',
    password: 'test123',
    administrador: 'true'
  };
}
