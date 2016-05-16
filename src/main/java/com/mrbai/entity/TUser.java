package com.mrbai.entity;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Cache;

import javax.persistence.*;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.sql.Date;

/**
 * Created by MirBai
 * on 2016/5/11.
 */
@Entity
@Table(name = "t_user", schema = "db_shiro")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "salt"})
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class TUser implements Serializable{

    private static final long serialVersionUID = 1L;

    private String userId;
    private String account;
    private String password;
    private String userName;
    private String telephone;
    private String email;
    private Date regDate;
    private String salt;
    private String roleId;
    private TRole tRole;
    private String credentialsSalt;

    @Transient
    public String getCredentialsSalt() {
        return account + salt;
    }

    public void setCredentialsSalt(String credentialsSalt) {
        this.credentialsSalt = credentialsSalt;
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
    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TUser tUser = (TUser) o;

        if (userId != null ? !userId.equals(tUser.userId) : tUser.userId != null) return false;
        if (account != null ? !account.equals(tUser.account) : tUser.account != null) return false;
        if (password != null ? !password.equals(tUser.password) : tUser.password != null) return false;
        if (userName != null ? !userName.equals(tUser.userName) : tUser.userName != null) return false;
        if (telephone != null ? !telephone.equals(tUser.telephone) : tUser.telephone != null) return false;
        if (email != null ? !email.equals(tUser.email) : tUser.email != null) return false;
        if (regDate != null ? !regDate.equals(tUser.regDate) : tUser.regDate != null) return false;
        if (salt != null ? !salt.equals(tUser.salt) : tUser.salt != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = userId != null ? userId.hashCode() : 0;
        result = 31 * result + (account != null ? account.hashCode() : 0);
        result = 31 * result + (password != null ? password.hashCode() : 0);
        result = 31 * result + (userName != null ? userName.hashCode() : 0);
        result = 31 * result + (telephone != null ? telephone.hashCode() : 0);
        result = 31 * result + (email != null ? email.hashCode() : 0);
        result = 31 * result + (regDate != null ? regDate.hashCode() : 0);
        result = 31 * result + (salt != null ? salt.hashCode() : 0);
        return result;
    }

    @ManyToOne(fetch = FetchType.LAZY)
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
