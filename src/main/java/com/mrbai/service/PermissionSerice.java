package com.mrbai.service;

import com.mrbai.entity.TPermission;
import com.mrbai.service.base.DaoService;

import java.util.List;

/**
 * Created by MirBai
 * on 2016/5/14.
 */
public interface PermissionSerice extends DaoService {


    List<TPermission> getPermissionByPermName(Object... permNames);
}
