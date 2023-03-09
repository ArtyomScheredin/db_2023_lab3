package model;

import com.vladmihalcea.hibernate.type.json.JsonBinaryType;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;
import org.hibernate.annotations.TypeDefs;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@TypeDefs({ @TypeDef(name = "jsonb", typeClass = JsonBinaryType.class) })
@Table(name = "actors")
public class Actor {

    public Actor() {
    }

    public Actor(String actorName, String rolesName) {
        this.actorName = actorName;
        this.rolesName = rolesName;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;

    @Column
    private String actorName;

    @Column(name = "RolesName", columnDefinition = "jsonb")
    @Type(type = "jsonb")
    private String rolesName;

    public String getActorName() {
        return actorName;
    }

    public void setActorName(String actorName) {
        this.actorName = actorName;
    }

    public String getRolesName() {
        return rolesName;
    }

    public void setRolesName(String salary) {
        this.rolesName = salary;
    }

    @Override
    public String toString() {
        return "Actor{" +
                "id=" + id +
                ", actorName='" + actorName + '\'' +
                ", rolesName='" + rolesName + '\'' +
                '}';
    }
}
