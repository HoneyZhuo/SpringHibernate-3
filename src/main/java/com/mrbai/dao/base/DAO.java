package com.mrbai.dao.base;

import java.io.Serializable;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
public interface DAO<T> {

    /**
     * @param o
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:19
     * @Method save
     * @Return void
     * @TODO 保存一个数据
     * @notice
     */
    public Serializable save(T o);

    /**
     * @param o
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:20
     * @Method delete
     * @Return void
     * @TODO 删除一个对象
     * @notice
     */
    public void delete(T o);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:21
     * @TODO 更新一个对象
     * @notice
     */
    public void update(T o);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:25
     * @TODO 保存或更改一个对象
     * @notice
     */
    public void saveOrUpdate(T o);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:26
     * @TODO 查询所有
     * @notice
     */
    public List<T> find(String hql);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:28
     * @TODO 条件查询
     * @notice
     */
    public List<T> find(String hql, Object[] param);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:28
     * @TODO 条件查询
     * @notice
     */
    public List<T> find(String hql, List<Object> param);

    /**
     * @param hql page(查询第几页) rows(每页显示几条记录) param(查询条件)
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:31
     * @Method find
     * @Return 集合
     * @TODO 条件查询, 分页
     * @notice
     */
    public List<T> find(String hql, Integer page, Integer rows, Object... param);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:34
     * @TODO 条件查询, 分页
     * @notice
     */
    public List<T> find(String hql, List<Object> param, Integer page, Integer rows);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:36
     * @TODO 获得一个对象
     * @notice
     */
    public T get(Class<T> clazz, Serializable id);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:37
     * @TODO 获得一个对象
     * @notice
     */
    public T get(String hql, Object... param);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:40
     * @TODO 获得一个对象
     * @notice
     */
    public T get(String hql, List<Object> param);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:41
     * @TODO 获得如count(*)或某条数据某个字段的值等数据
     * @notice
     */
    public Object likeCount(String hql);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:41
     * @TODO 获得如count(*)或某条数据某个字段的值等数据
     * @notice
     */
    public Object likeCount(String hql, Object... param);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:44
     * @TODO 执行 HQL 语句,返回响应的数目
     * @notice
     */
    public Integer executeHql(String hql);

    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:44
     * @TODO 执行 HQL 语句,返回响应的数目
     * @notice
     */
    public Integer executeHql(String hql, Object... param);

    /**
     *  @Author 白景川【baijc1234@126.com】
     *  @Date 2016/5/14 11:10
     *  @TODO 执行 where id in (ids) 类型的 HQL 语句,返回响应的数目
     *  @notice query.setParameterList();
     */
    public Integer executeHqlIn(String hql, Object... param);
    /**
     * @Author 白景川【baijc1234@126.com】
     * @Date 2016/4/24 0:44
     * @TODO 执行 HQL 语句,返回响应的数目
     * @notice
     */
    public Integer executeHql(String hql, List<Object> param);

    /**
     *  @Author 白景川【baijc1234@126.com】
     *  @Date 2016/4/27 17:28
     *  @TODO 执行 HQL 语句,返回某一列的集合
     *  @notice
     */
    public List<Object> querySingleColumn(String hql, Object... param);
}
