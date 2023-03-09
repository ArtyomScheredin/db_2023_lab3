package DTO;

import java.util.List;

public record ActorDTO(String actorName, List<RoleDTO> roles) {
}
