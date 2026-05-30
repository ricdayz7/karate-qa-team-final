package bdd;

import com.intuit.karate.junit5.Karate;

public class TestRunner {

    @Karate.Test
    Karate testAllByTags() {
        String tags = System.getProperty("karate.tags");
        // Escanea TODOS los .feature bajo src/test/java/bdd
        Karate runner = Karate.run().path("classpath:bdd");

        if (tags != null && !tags.trim().isEmpty()) {
            runner = runner.tags(tags.trim());
        }

        return runner;
    }
}