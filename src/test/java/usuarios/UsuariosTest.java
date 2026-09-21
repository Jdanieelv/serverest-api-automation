package usuarios;

import com.intuit.karate.junit5.Karate;

class UsuariosTest {

    @Karate.Test
    Karate testAll() {
        return Karate.run("usuarios").relativeTo(getClass());
    }

    @Karate.Test
    Karate testByTag() {
        return Karate.run("usuarios").tags("@listar").relativeTo(getClass());
    }
}
