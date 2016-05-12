package com.mrbai.entity;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;

import javax.persistence.*;
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
    private String permission;
    private String roleId;
    private String description;
    private Set<TRole> tRoles;

    @Id
    @Column(name = "perm_id")
    public String getPermId() {
        return permId;
    }

    public void setPermId(String permId) {
        this.permId = permId;
    }

    @Basic
    @Column(name = "permission")
    public String getPermission() {
        return permission;
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    @Basic
    @Column(name = "role_id")
    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
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
        if (permission != null ? !permission.equals(that.permission) : that.permission != null) return false;
        if (roleId != null ? !roleId.equals(that.roleId) : that.roleId != null) return false;
        if (description != null ? !description.equals(that.description) : that.description != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = permId != null ? permId.hashCode() : 0;
        result = 31 * result + (permission != null ? permission.hashCode() : 0);
        result = 31 * result + (roleId != null ? roleId.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        return result;
    }

    @ManyToMany(mappedBy = "tPermissions")
    @JsonIgnore
    public Set<TRole> gettRoles() {
        return tRoles;
    }

    public void settRoles(Set<TRole> tRoles) {
        this.tRoles = tRoles;
    }
}
