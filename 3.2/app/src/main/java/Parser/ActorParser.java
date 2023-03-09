package Parser;

import DTO.ActorDTO;
import DTO.RoleDTO;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class ActorParser {
    private static HashMap<ActorFields, Pattern> pattern = new HashMap<>();

    static {
        pattern.put(ActorFields.GET_ACTOR_NAME, Pattern.compile("^.*\\b(?=\\t)"));
        pattern.put(ActorFields.GET_TITLE, Pattern.compile("[^\\t\\\"]+?(?=\\\"?\\s\\()"));
        pattern.put(ActorFields.GET_YEAR, Pattern.compile("(?<=\\()[0-9]{4}(?=\\))"));
        pattern.put(ActorFields.GET_TYPE, Pattern.compile("(?<=\\([0-9]{4}\\)\\s\\()(V|TV|VG|archive footage|uncredited|voice)?(?=\\)\\s?\\{?)"));
        pattern.put(ActorFields.GET_SERIES_NAME, Pattern.compile("(?<=\\{).*?(?=\\})"));
        pattern.put(ActorFields.GET_AS_CHARACTER, Pattern.compile("\\b(?!(V|TV|VG|archive footage|uncredited|voice)\\b)(?<=(\\}|\\))\\s{1,3}\\().*(?=\\)\\s{1,3}(\\[|<|^))"));
        pattern.put(ActorFields.GET_CHARACTER_NAME, Pattern.compile("(?<=\\[).*?(?=\\])"));
        pattern.put(ActorFields.GET_CREDIT, Pattern.compile("(?<=\\<).*?(?=\\>)"));
    }

    public static List<ActorDTO> parseFile(File file, int count) throws IOException {
        final ArrayList<ActorDTO> result = new ArrayList<>(count);
        final StringActorIterator stringActorIterator = new StringActorIterator(file);
        for (int i = 0; i < count; i++) {
            String next = stringActorIterator.next();
            if (next == null) {
                throw new RuntimeException("Not enough data in file to get " + count + " actors");
            }
            result.add(parseActor(next));
        }

        return result;
    }

    private static ActorDTO parseActor(String next) {
        String name = getFieldFromString(ActorFields.GET_ACTOR_NAME, next);
        List<RoleDTO> roles = new ArrayList<>();
        for (String line : next.split("\t\t\t")) {
            String title = getFieldFromString(ActorFields.GET_TITLE, line);
            String year = getFieldFromString(ActorFields.GET_YEAR, line);
            String type = getFieldFromString(ActorFields.GET_TYPE, line);
            String seriesName = getFieldFromString(ActorFields.GET_SERIES_NAME, line);
            String asCharacter = getFieldFromString(ActorFields.GET_AS_CHARACTER, line);
            String characterName = getFieldFromString(ActorFields.GET_CHARACTER_NAME, line);
            String credit = getFieldFromString(ActorFields.GET_CREDIT, line);
            if (characterName != null && asCharacter != null) {
                characterName += ' ' + asCharacter;
            }
            roles.add(new RoleDTO(title,year,type,seriesName,characterName,credit));
        }
        return new ActorDTO(name, roles);
    }

    private static String getFieldFromString(ActorFields getActorName, String next) {
        try {
            Matcher matcher = pattern.get(getActorName).matcher(next);
            matcher.find();
            return matcher.group();
        } catch (Exception e) {
            return null;
        }
    }

    private enum ActorFields {
        GET_ACTOR_NAME,
        GET_TITLE,
        GET_YEAR,
        GET_TYPE,
        GET_SERIES_NAME,
        GET_AS_CHARACTER,
        GET_CHARACTER_NAME,
        GET_CREDIT
    }

    private static class StringActorIterator implements Iterator<String> {
        private BufferedReader reader;
        private String next;

        public StringActorIterator(File file) throws FileNotFoundException {
            this.reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
        }

        @Override
        public void remove() {
            Iterator.super.remove();
        }

        @Override
        public void forEachRemaining(Consumer<? super String> action) {
            Iterator.super.forEachRemaining(action);
        }

        @Override
        public boolean hasNext() {
            if (next == null) {
                try {
                    readNext();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
            return next != null;
        }

        private void readNext() throws IOException {

        }

        @Override
        public String next() {StringBuilder result = new StringBuilder();
            try {
                for (String cur = reader.readLine();
                     !Objects.equals(cur, "");
                     cur = reader.readLine()) {
                    if (cur == null) {
                        return null;
                    }
                    result.append(cur);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            return result.toString();
        }
    }
}
