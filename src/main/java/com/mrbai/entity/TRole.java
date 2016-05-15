package com.mrbai.entity;

import com.sun.istack.internal.Nullable;
import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/5/11.
 */
@Entity
@Table(name = "t_role", schema = "db_shiro")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class TRole implements Serializable{

    private static final long serialVersionUID = 1L;

    private String roleId;
    private String roleName;
    private String roleKey;
    private String description;
    private List<TUser> tUsers;
    private List<TPermission> tPermissions;

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(name = "role_id")
    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    @Basic
    @Column(name = "role_name")
    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    @Basic
    @Column(name = "role_key")
    public String getRoleKey() {
        return roleKey;
    }

    public void setRoleKey(String roleKey) {
        this.roleKey = roleKey;
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

        TRole tRole = (TRole) o;

        if (roleId != null ? !roleId.equals(tRole.roleId) : tRole.roleId != null) return false;
        if (roleName != null ? !roleName.equals(tRole.roleName) : tRole.roleName != null) return false;
        if (roleKey != null ? !roleKey.equals(tRole.roleKey) : tRole.roleKey != null) return false;
        if (description != null ? !description.equals(tRole.description) : tRole.description != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = roleId != null ? roleId.hashCode() : 0;
        result = 31 * result + (roleName != null ? roleName.hashCode() : 0);
        result = 31 * result + (roleKey != null ? roleKey.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        return result;
    }

    @OneToMany(mappedBy = "tRole",fetch = FetchType.LAZY)
    @JsonIgnore
    public List<TUser> gettUsers() {
        return tUsers;
    }

    public void settUsers(List<TUser> tUsers) {
        this.tUsers = tUsers;
    }

    @ManyToMany
    @Nullable
    @JoinTable(name = "t_role_perm", schema = "db_shiro", joinColumns = @JoinColumn(name = "role_id", referencedColumnName = "role_id"), inverseJoinColumns = @JoinColumn(name = "perm_id", referencedColumnName = "perm_id"))
    public List<TPermission> gettPermissions() {
        return tPermissions;
    }

    public void settPermissions(List<TPermission> tPermissions) {
        this.tPermissions = tPermissions;
    }
}
