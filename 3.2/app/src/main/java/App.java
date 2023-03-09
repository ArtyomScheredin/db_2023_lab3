import DTO.ActorDTO;
import Parser.ActorParser;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class App {

    public static final String PWD = "Raslex481756";
    static class A {
        Integer a;
        Integer b;

        public A(Integer a, Integer b) {
            this.a = a;
            this.b = b;
        }

        public Integer getA() {
            return a;
        }

        public void setA(Integer a) {
            this.a = a;
        }

        public Integer getB() {
            return b;
        }

        public void setB(Integer b) {
            this.b = b;
        }
    }
    public static void main(String[] args) throws IOException {
        List<ActorDTO> actorDTOS = ActorParser.parseFile(new File("3.2/app/src/main/resources/actors.list.txt"),
                                                         4000);
        saveMyObject(actorDTOS);
    }

    public static void saveMyObject(List<ActorDTO> actorDTOs) {
        String sql = "INSERT INTO actors (actorname, rolesname) VALUES (?, ?::jsonb)";
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_NULL_MAP_VALUES, false);
        objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        try (Connection con = DriverManager
                .getConnection("jdbc:postgresql://localhost:5434/postgres", "postgres", PWD);
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            for (ActorDTO actorDTO : actorDTOs) {
                System.out.println(objectMapper.writeValueAsString(actorDTO) +'\n');
                pstmt.setString(1, actorDTO.actorName());
                pstmt.setString(2, objectMapper.writeValueAsString(actorDTO.roles()));
                pstmt.executeUpdate();
            }
        } catch (SQLException  e) {
            throw new RuntimeException(e);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}
