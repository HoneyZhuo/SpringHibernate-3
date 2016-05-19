package com.mrbai.dao.base.Impl;

import com.mrbai.dao.base.DAO;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.io.Serializable;
import java.util.List;

/**
 * Created by MirBai
 * on 2016/4/24.
 */
//@Component组件不好归类时使用该注解
@Repository   //专门用来标记DAO（即访问数据库）层
public class DaoImpl<T> implements DAO<T> {

    @Resource(name = "sessionFactory")
    private SessionFactory sessionFactory;

    public Session getSession(){
        return sessionFactory.getCurrentSession();
    }

    public Serializable save(T o) {
       return getSession().save(o);
    }

    public void delete(T o) {
        getSession().delete(o);
    }

    public void update(T o) {
        getSession().update(o);
    }

    public void saveOrUpdate(T o) {
        getSession().saveOrUpdate(o);
    }

    @SuppressWarnings("unchecked")
    public List<T> find(String hql) {
        Query query = getSession().createQuery(hql);
        return query.list();
    }

    @SuppressWarnings("unchecked")
    public List<T> find(String hql, Object[] param) {
        Query query = getSession().createQuery(hql);
        if (param != null && param.length > 0 && !hql.contains("in")){
            for (int i = 0; i < param.length; i++) {
                query.setParameter(i+1 +"",param[i]);
            }
        }else if (param != null && param.length > 0 && hql.contains("in")){
            query.setParameterList(1 +"", param);
        }
        return query.list();
    }

    @SuppressWarnings("unchecked")
    public List<T> find(String hql, List<Object> param) {
        Query query = getSession().createQuery(hql);
        if (param != null && param.size() > 0 && !hql.contains("in")){
            for (int i = 0; i < param.size(); i++) {
                query.setParameter(i + 1 +"", param.get(i));
            }
        }else if (param != null && param.size() > 0 && hql.contains("in")){
                query.setParameterList(1 +"", param);
        }
        return query.list();
    }

    @SuppressWarnings("unchecked")
    public List<T> find(String hql, Integer page, Integer rows, Object... param) {
        if (page == null || page < 1){
            page = 1;
        }
        if (rows == null || rows < 1){
            rows = 5;
        }
        Query query = getSession().createQuery(hql);
        if (param != null && param.length > 0){
            for (int i = 0; i < param.length; i++) {
                query.setParameter(i + 1 + "", param[i]);
            }
        }
        return query.setFirstResult((page - 1) * rows).setMaxResults(rows).list();
    }

    @SuppressWarnings("unchecked")
    public List<T> find(String hql, List<Object> param, Integer page, Integer rows) {
        if (page == null || page < 1){
            page = 1;
        }
        if (rows == null || rows < 1){
            rows = 5;
        }
        Query query = getSession().createQuery(hql);
        if (param != null && param.size() > 0){
            for (int i = 0; i < param.size(); i++) {
                query.setParameter(i + 1 + "", param.get(i));
            }
        }
        return query.setFirstResult((page - 1) * rows).setMaxResults(rows).list();
    }
    @SuppressWarnings("unchecked")
    public T get(Class<T> clazz, Serializable id) {
        return (T) getSession().get(clazz, id);
    }
    @SuppressWarnings("unchecked")
    public T get(String hql, Object... param) {
        List<T> t = find(hql, param);
        if (t != null && t.size() > 0){
            return t.get(0);
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    public T get(String hql, List<Object> param) {
        List<T> t = find(hql, param);
        if (t != null && t.size() > 0){
            return t.get(0);
        }
        return null;
    }

    public Object likeCount(String hql) {
        return getSession().createQuery(hql).uniqueResult();
    }

    public Object likeCount(String hql, Object... param) {
        Query query = getSession().createQuery(hql);
        if (param != null && param.length > 0){
            for (int i = 0; i < param.length; i++) {
                query.setParameter(i + 1 + "", param[i]);
            }
        }
        return query.uniqueResult();
    }

    public Integer executeHql(String hql) {

        return getSession().createQuery(hql).executeUpdate();
    }

    public Integer executeHql(String hql, Object[] param) {
        Query query = getSession().createQuery(hql);
        if (param != null && param.length > 0){
            for (int i = 0; i < param.length; i++) {
                query.setParameter(i + 1 + "", param[i]);
            }
        }
        return query.executeUpdate();
    }

    @SuppressWarnings("unchecked")
    public Integer executeHqlIn(String hql, Object... param) {
        Query query = getSession().createQuery(hql);
        query.setParameterList(1 + "", param);
        return query.executeUpdate();
    }

    @SuppressWarnings("unchecked")
    public Integer executeHql(String hql, List<Object> param) {
        Query query = getSession().createQuery(hql);
        if (param != null && param.size() > 0){
            for (int i = 0; i < param.size(); i++) {
                query.setParameter(i + 1 + "", param.get(i));
            }
        }
        return query.executeUpdate();
    }

    @SuppressWarnings("unchecked")
    public List<Object> querySingleColumn(String hql, Object... param) {
        Query query = getSession().createQuery(hql);
        if (param != null && param.length > 0){
            for (int i = 0; i < param.length; i++) {
                query.setParameter(i + 1 + "",param[i]);
            }
        }
        List<Object> objects = query.list();
        return objects;
    }
}
