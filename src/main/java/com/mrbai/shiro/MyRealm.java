package com.mrbai.shiro;

import com.mrbai.entity.TPermission;
import com.mrbai.entity.TRole;
import com.mrbai.entity.TUser;
import com.mrbai.service.UserService;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.cache.CacheManager;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;

import javax.annotation.Resource;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
public class MyRealm extends AuthorizingRealm {

    private static final long serialVersionUID = 1L;

    public MyRealm(CacheManager cacheManager) {
        super(cacheManager);
    }

    @Resource(name = "userServiceImpl")
    UserService userService;

    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        String account = (String) principals.getPrimaryPrincipal();
        TUser tUser = userService.getUserByAccount(account);
        TRole tRole = tUser.gettRole();
        String roleName = tRole.getRoleName();
        Set<String> roleNames = new HashSet<String>();
        roleNames.add(roleName);

        List<TPermission> permission = tRole.gettPermissions();
        Set<String> permNames = new HashSet<String>();
        for (int i = 0; i < permission.size(); i++) {
            TPermission tPermission =  permission.get(i);
            permNames.add(tPermission.getPermName());
        }

        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        info.setRoles(roleNames);
        info.setStringPermissions(permNames);
        return info;
    }

    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        String account = (String) token.getPrincipal();
        TUser tUser = userService.getUserByAccount(account);

        /*if(Boolean.TRUE.equals(tUser.getLocked())) {
            throw new LockedAccountException(); //帐号锁定
        }*/

        if (tUser != null){
//            SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(tUser.getAccount(), tUser.getPassword(),getName());
            //交给 AuthenticatingRealm 使用 CredentialsMatcher 进行密码匹配， 如果觉得人家
            //的不好可以在此判断或自定义实现
            SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(
                    tUser.getAccount(), //用户名
                    tUser.getPassword(), //密码
                    ByteSource.Util.bytes(tUser.getCredentialsSalt()),//salt=username+salt
                    getName() //realm name
            );
            return info;
        }
        return null;
    }

    @Override
    public void clearCachedAuthorizationInfo(PrincipalCollection principals) {
        super.clearCachedAuthorizationInfo(principals);
    }

    @Override
    public void clearCachedAuthenticationInfo(PrincipalCollection principals) {
        super.clearCachedAuthenticationInfo(principals);
    }

    @Override
    public void clearCache(PrincipalCollection principals) {
        super.clearCache(principals);
    }

    public void clearAllCachedAuthorizationInfo() {
        getAuthorizationCache().clear();
    }

    public void clearAllCachedAuthenticationInfo() {
        getAuthenticationCache().clear();
    }

    public void clearAllCache() {
        clearAllCachedAuthenticationInfo();
        clearAllCachedAuthorizationInfo();
    }
}
