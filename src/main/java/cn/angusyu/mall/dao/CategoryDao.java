package cn.angusyu.mall.dao;

import cn.angusyu.mall.entity.Category;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author AngusYu
 */
public interface CategoryDao {

    Integer insertCategory(@Param("category") Category category);

    Integer updateDeleteByIds(List<Long> ids);

    Integer updateCategory(@Param("category") Category category);

    Integer updateIncreaseProductAmountById(Long id);

    Integer updateDecreaseProductAmountById(Long id);

    Long getIdById(Long id);

    Long getIdByName(String name);

    Category getById(Long id);

    List<Category> listAll();

    List<Category> listAllFuzzyQueryByName(@Param("fuzzyParam") String fuzzyParam);
}
