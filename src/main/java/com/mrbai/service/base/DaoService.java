package com.mrbai.service.base;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
public interface DaoService {

    //也就是直接性的什么都没有，只为了实现类节省每个扩展service的@transaction
    //将@transaction标记到BaseServiceImpl上
}
