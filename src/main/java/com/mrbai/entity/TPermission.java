package com.mrbai.entity;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

/**
 * Created by MirBai
 * on 2016/5/11.
 */
@Entity
@Table(name = "t_permission", schema = "db_shiro")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class TPermission {
    private String permId;
    private String permName;
    private String description;
    private List<TRole> tRoles;

    @Id
    @Column(name = "perm_id")
    public String getPermId() {
        return permId;
    }

    public void setPermId(String permId) {
        this.permId = permId;
    }

    @Basic
    @Column(name = "perm_name")
    public String getPermName() {
        return permName;
    }

    public void setPermName(String permName) {
        this.permName = permName;
    }

    @Basic
    @Column(name = "description")
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TPermission that = (TPermission) o;

        if (permId != null ? !permId.equals(that.permId) : that.permId != null) return false;
        if (permName != null ? !permName.equals(that.permName) : that.permName != null) return false;
        if (description != null ? !description.equals(that.description) : that.description != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = permId != null ? permId.hashCode() : 0;
        result = 31 * result + (permName != null ? permName.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        return result;
    }

    @ManyToMany(mappedBy = "tPermissions")
    @JsonIgnore
    public List<TRole> gettRoles() {
        return tRoles;
    }

    public void settRoles(List<TRole> tRoles) {
        this.tRoles = tRoles;
    }
}
