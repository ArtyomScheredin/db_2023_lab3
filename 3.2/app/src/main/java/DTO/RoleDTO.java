package DTO;

public record RoleDTO(String title,
                      String year,
                      String type,
                      String seriesName,
                      String mainCharacterName,
                      String credit) {
    @Override
    public String toString() {
        return "RoleDTO{" +
                "title='" + title + '\'' +
                ", year='" + year + '\'' +
                ", types=" + type +
                ", seriesName='" + seriesName + '\'' +
                ", mainCharacterName='" + mainCharacterName + '\'' +
                ", credit='" + credit + '\'' +
                '}';
    }
}
