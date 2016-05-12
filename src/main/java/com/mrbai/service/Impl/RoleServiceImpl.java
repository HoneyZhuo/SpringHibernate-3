package com.mrbai.service.Impl;

import com.mrbai.dao.base.DAO;
import com.mrbai.entity.TRole;
import com.mrbai.service.RoleService;
import com.mrbai.service.base.DaoService;
import com.mrbai.service.base.Impl.DaoServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/26.
 */
@Service
public class RoleServiceImpl extends DaoServiceImpl implements DaoService, RoleService {

    @Resource(name = "daoImpl")
    DAO<TRole> tRoleDAO;

    public DAO<TRole> gettRoleDAO() {
        return tRoleDAO;
    }

    public void settRoleDAO(DAO<TRole> tRoleDAO) {
        this.tRoleDAO = tRoleDAO;
    }


    public TRole getRoleByRoleKey(String roleKey) {
        String hql = "select tr from TRole tr where tr.roleKey = ?1";
        return tRoleDAO.get(hql,roleKey);
    }

    public List<TRole> getRoleByPage(int pageNo) {
        String hql = "select tr from TRole tr";
        System.out.println(tRoleDAO.find(hql,null,pageNo,0));
        return tRoleDAO.find(hql,null,pageNo,0);
    }

    public void addRole(TRole tRole) {
        tRoleDAO.save(tRole);
    }
}
