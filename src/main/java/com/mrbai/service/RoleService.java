package com.mrbai.service;

import com.mrbai.entity.TRole;
import com.mrbai.service.base.DaoService;

/**
 * Created by MirBai
 * on 2016/4/26.
 */
public interface RoleService extends DaoService {


    TRole getRoleByRoleName(String roleName);
}
