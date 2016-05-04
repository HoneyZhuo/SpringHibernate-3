package com.mrbai.entity;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Collection;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
@Entity
@Table(name = "t_role", schema = "db_shiro")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class TRole implements Serializable {

    private static final long serialVersionUID = 1L;

    private String roleId;
    private String roleName;
    private Collection<TUser> tUsers;
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

    @OneToMany(cascade = CascadeType.ALL,mappedBy = "tRole")
    @JsonIgnore
    public Collection<TUser> gettUsers() {
        return tUsers;
    }

    public void settUsers(Collection<TUser> tUsers) {
        this.tUsers = tUsers;
    }
}
