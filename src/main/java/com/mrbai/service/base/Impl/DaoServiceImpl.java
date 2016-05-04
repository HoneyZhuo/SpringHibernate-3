package com.mrbai.service.base.Impl;

import com.mrbai.service.base.DaoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
@Service
@Transactional(readOnly = false,propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class DaoServiceImpl implements DaoService {

}
