package com.mrbai.service.Impl;

import com.mrbai.dao.base.DAO;
import com.mrbai.entity.TPermission;
import com.mrbai.service.PermissionSerice;
import com.mrbai.service.base.DaoService;
import com.mrbai.service.base.Impl.DaoServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/5/14.
 */
@Service
public class PermissionServiceImpl extends DaoServiceImpl implements DaoService,PermissionSerice{

    @Resource(name = "daoImpl")
    DAO<TPermission> tPermissionDAO;

    public DAO<TPermission> gettPermissionDAO() {
        return tPermissionDAO;
    }

    public void settPermissionDAO(DAO<TPermission> tPermissionDAO) {
        this.tPermissionDAO = tPermissionDAO;
    }

    public List<TPermission> getPermissionByPermName(Object... permNames) {
        String hql = "select tp from TPermission tp where tp.permName in (?1)";
        return tPermissionDAO.find(hql, permNames);
    }
}
