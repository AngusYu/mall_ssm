package cn.angusyu.mall.dao;

import cn.angusyu.mall.entity.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author AngusYu
 */
public interface ProductDao {

    Integer insertProduct(@Param("product") Product product);

    Integer updateDeleteByIds(List<Long> ids);

    Integer updateProduct(@Param("product") Product product);

    Long getIdById(Long id);

    Long getIdByName(String name);

    Long getCategoryIdById(Long id);

    Product getById(Long id);

    List<Product> listAll();

    List<Product> listAllQueryByFuzzyParam(@Param("fuzzyParam") String fuzzyParam);
}
