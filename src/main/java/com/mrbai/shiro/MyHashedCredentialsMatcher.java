package com.mrbai.shiro;

import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SaltedAuthenticationInfo;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.codec.Base64;
import org.apache.shiro.codec.Hex;
import org.apache.shiro.crypto.hash.AbstractHash;

/**
 * Created by MirBai
 * on 2016/5/1.
 *
 *
 * notice:单纯的登录验证无需自定义CredentialsMatcher
 */
public class MyHashedCredentialsMatcher extends HashedCredentialsMatcher {

    public boolean doCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) {
        boolean matches = super.doCredentialsMatch(token, info);
        return matches;
    }
}
