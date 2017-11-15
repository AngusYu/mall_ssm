package cn.angusyu.mall.dao;

import cn.angusyu.mall.entity.Admin;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AdminDao {

    Integer insertAdmin(@Param("admin") Admin admin);

    Integer updateDeleteByIds(List<Long> ids);

    Integer updateAdmin(@Param("admin") Admin admin);

    Admin getById(Long id);

    Admin getByLoginName(String loginName);

    Admin getByLoginNameCaseSensitive(String loginName);

    List<Admin> listAll();

    List<Admin> listAllQueryByFuzzyParam(@Param("fuzzyParam") String fuzzyParam);
}
