package com.mrbai.service;

import com.mrbai.entity.TUser;
import com.mrbai.service.base.DaoService;

import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
public interface UserService extends DaoService {

    void save(TUser tUser);

    void find();

    TUser getUserByAccount(String account);

    Object getAccountCount(String account);

    void registUser(TUser tUser);

    List<TUser> getUserByPage(int pageNo);

    boolean deleteUser(String userId);

    int editUser(Object[] values);

    int deleteUsers(Object[] userIdList);

    Long getUserCount();
}
