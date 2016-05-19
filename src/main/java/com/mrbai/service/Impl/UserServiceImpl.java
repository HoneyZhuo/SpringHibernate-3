package com.mrbai.service.Impl;

import com.mrbai.dao.base.DAO;
import com.mrbai.entity.TUser;
import com.mrbai.service.UserService;
import com.mrbai.service.base.DaoService;
import com.mrbai.service.base.Impl.DaoServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
@Service
public class UserServiceImpl extends DaoServiceImpl implements UserService,DaoService {

    @Resource(name = "daoImpl")
    private DAO<TUser> tUserDAO;

    @Resource(name = "passwordHalper")
    private PasswordHalper passwordHalper;

    public DAO<TUser> gettUserDAO() {
        return tUserDAO;
    }

    public void settUserDAO(DAO<TUser> tUserDAO) {
        this.tUserDAO = tUserDAO;
    }

    public void save(TUser tUser) {
        passwordHalper.encryptPassword(tUser);
        tUserDAO.save(tUser);
    }
    public void find() {
        String hql = "from TUser";
        gettUserDAO().find(hql);
    }

    public TUser getUserByAccount(String account) {
        String hql = "select tu from TUser tu where tu.account = ?1";
        return tUserDAO.get(hql, account);
    }

    public Object getAccountCount(String account) {
        String hql = "select count(tu.userId) from TUser tu where tu.account = ?1";
        return tUserDAO.likeCount(hql,account);
    }

    public void registUser(TUser tUser) {
        passwordHalper.encryptPassword(tUser);
        tUserDAO.save(tUser);
    }

    public List<TUser> getUserByPage(int pageNo) {
        String hql = "select tu from TUser tu order by regDate";
        System.out.println(tUserDAO.find(hql,null,pageNo,0));
        return tUserDAO.find(hql,null,pageNo,0);
    }

    public boolean deleteUser(String userId) {
        TUser tUser = tUserDAO.get(TUser.class,userId);
        if (tUser != null){
            tUserDAO.delete(tUser);
            return true;
        }
        return false;
    }

    public int editUser(Object[] values) {
        String hql = "update TUser set userName = ?1, email = ?2, telephone = ?3, tRole = ?4 where userId = ?5";
        return tUserDAO.executeHql(hql, values);
    }

    public int deleteUsers(Object[] userIdList) {
        String hql = "delete from TUser where userId in (?1)";
        return tUserDAO.executeHqlIn(hql, userIdList);
    }

    @Override
    public Long getUserCount() {
        String hql="select count(*) from TUser";
        Long count = (Long) tUserDAO.likeCount(hql);
        return count;
    }
}
