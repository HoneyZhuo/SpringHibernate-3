package com.mrbai.service;

import com.mrbai.entity.TRole;
import com.mrbai.service.base.DaoService;

import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/26.
 */
public interface RoleService extends DaoService {


    TRole getRoleByRoleKey(String roleKey);

    List<TRole> getRoleByPage(int pageNo);

    void addRole(TRole tRole);
}
