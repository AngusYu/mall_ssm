package cn.angusyu.mall.service;

import cn.angusyu.mall.entity.Category;
import cn.angusyu.mall.dto.PaginationResult;

import java.util.List;

/**
 * @author AngusYu
 */
public interface CategoryService {

    Integer insertCategory(Category category);

    Integer deleteCategoryByIds(List<Long> ids);

    Integer updateCategory(Category category);

    Category getCategoryById(Long id);

    PaginationResult listCategories(Integer page, Integer rows, String fuzzyParam);

    List<Category> listAllCategories();

    Boolean checkCategoryName(String name);
}
