Module module {
    name = 'fr.epardaud.net';
    version = '0.5';
    by = {"Stéphane Épardaud"};
    license = 'Apache Software License';
    doc = "A module that contains URI stuff";
    dependencies = {
        Import {
            name = 'fr.epardaud.collections';
            version = '0.2';
        },
        Import {
            name = 'fr.epardaud.iop';
            version = '0.1';
        },
        Import {
            name = 'fr.epardaud.json';
            version = '0.2';
        }
    };
}