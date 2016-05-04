package com.mrbai.entity;

import com.sun.istack.internal.NotNull;
import com.sun.istack.internal.Nullable;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.hibernate.annotations.*;

import javax.persistence.*;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.sql.Date;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
@Entity
@Table(name = "t_user", schema = "db_shiro")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "salt"})
public class TUser implements Serializable {

    private static final long serialVersionUID = 1L;

    private String userId;
    private String account;
    private String password;
    private String userName;
    private String telephone;
    private String email;
    private Date regDate;
    private String roleId;
    private String salt;
    private TRole tRole;
    private String credentialsSalt;

    public void setCredentialsSalt(String credentialsSalt) {
        this.credentialsSalt = credentialsSalt;
    }

    @Transient
    public String getCredentialsSalt() {
        return account + salt;
    }

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(name = "user_id")
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Basic
    @Column(name = "account")
    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    @Basic
    @Column(name = "password")
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Basic
    @Column(name = "user_name")
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Basic
    @Column(name = "telephone")
    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    @Basic
    @Column(name = "email")
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Basic
    @Column(name = "reg_date")
    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    @Basic
    @Column(name = "salt")
    @Nullable
    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    @ManyToOne
    @JoinColumn(name = "role_Id")
    public TRole gettRole() {
        return tRole;
    }

    public void settRole(TRole tRole) {
        this.tRole = tRole;
    }

    //@Basic
    @Column(name = "role_Id")
    @Transient
    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}
