package cn.angusyu.mall.service.impl;

import cn.angusyu.mall.dao.CategoryDao;
import cn.angusyu.mall.entity.Category;
import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.service.CategoryService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static cn.angusyu.mall.util.Constant.VARCHAR_MAX_LENGTH_20;
import static cn.angusyu.mall.util.Constant.ZERO_ID;

/**
 * @author AngusYu
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CategoryDao categoryDao;

    @Override
    public Integer insertCategory(Category category) {
        Category c = verifyInsertCategory(category);
        if (c != null) {
            return categoryDao.insertCategory(c);
        }
        return -1;
    }

    @Override
    public Integer deleteCategoryByIds(List<Long> ids) {
        List<Long> i = verifyAndFixIds(ids);
        if (i != null) {
            return categoryDao.updateDeleteByIds(i);
        }
        return -1;
    }

    @Override
    public Integer updateCategory(Category category) {
        Category c = verifyUpdateCategory(category);
        if (c != null) {
            return categoryDao.updateCategory(c);
        }
        return -1;
    }

    @Override
    public Category getCategoryById(Long id) {
        if (id != null && id > ZERO_ID) {
            return categoryDao.getById(id);
        }
        return null;
    }

    @Override
    public PaginationResult listCategories(Integer page, Integer rows, String fuzzyParam) {
        if (page == null || rows == null) {
            page = 1;
            rows = 15;
        }
        PageInfo pageInfo;
        List<Category> categories;
        PageHelper.startPage(page, rows);
        if (fuzzyParam == null || "".equals(fuzzyParam)) {
            categories = categoryDao.listAll();
        } else {
            categories = categoryDao.listAllFuzzyQueryByName(fuzzyParam);
        }
        pageInfo = new PageInfo<>(categories);
        return new PaginationResult(pageInfo.getTotal(), categories);
    }

    @Override
    public List<Category> listAllCategories() {
        return categoryDao.listAll();
    }

    @Override
    public Boolean checkCategoryName(String name) {
        boolean isNameValid = name.length() > 0 && name.length() <= VARCHAR_MAX_LENGTH_20;
        if (isNameValid) {
            isNameValid = categoryDao.getIdByName(name) == null;
        }
        return isNameValid;
    }

    private Category verifyInsertCategory(Category category) {
        boolean isNameNotNull;
        boolean isNameExist;
        int l;
        if (category != null) {
            isNameNotNull = category.getName() != null && !"".equals(category.getName());
            if (isNameNotNull) {
                l = category.getName().length();
                if (l > VARCHAR_MAX_LENGTH_20) {
                    logger.info("verifyInsertCategory: category.name is to long, cut out to 20.");
                    category.setName(category.getName().substring(0, VARCHAR_MAX_LENGTH_20));
                }
                isNameExist = categoryDao.getIdByName(category.getName()) != null;
                if (isNameExist) {
                    logger.info("verifyInsertCategory: category.name already exist.");
                    return null;
                } else {
                    if (category.getHot() == null) {
                        category.setHot(false);
                    }
                    return category;
                }
            } else {
                logger.info("verifyInsertCategory: category.name is null.");
            }
        }
        return null;
    }

    private List<Long> verifyAndFixIds(List<Long> ids) {
        Set idSet;
        ids.removeAll(Collections.singleton(null));
        //  set negative value to ZERO_ID
        for (int i = 0; i < ids.size(); i++) {
            if (ids.get(i) < ZERO_ID) {
                ids.set(i, ZERO_ID);
            }
        }
        //  remove duplicate value
        idSet = new HashSet(ids);
        //  remove ZERO_ID
        idSet.remove(ZERO_ID);
        logger.info("verifyAndFixIds: After filter null, negative, duplicate and ZERO_ID item=" + idSet.toString());
        ids.clear();
        if (idSet.size() > 0) {
            for (Object o : idSet) {
                if (categoryDao.getIdById((Long) o) != null) {
                    ids.add((Long) o);
                }
            }
            logger.info("verifyAndFixIds: After filter non exist item=" + ids);
            if (ids.size() > 0) {
                return ids;
            }
        }
        return null;
    }

    private Category verifyUpdateCategory(Category category) {
        boolean isCategoryIdNotNull;
        if (category != null && category.getId() != null) {
            Category categoryGetById = categoryDao.getById(category.getId());
            if (categoryGetById != null) {
                boolean isNameExist;
                if (category.getName() != null) {
                    if (category.getName().length() > VARCHAR_MAX_LENGTH_20) {
                        category.setName(category.getName().substring(0, VARCHAR_MAX_LENGTH_20));
                    }
                    if (category.getName().equals(categoryGetById.getName())) {
                        logger.info("verifyUpdateCategory: category.name is useless, set to null.");
                        category.setName(null);
                    } else {
                        isNameExist = categoryDao.getIdByName(category.getName()) != null;
                        if (isNameExist) {
                            logger.info("verifyUpdateCategory: category.name already exist, set to null.");
                            category.setName(null);
                        }
                    }
                }
                boolean isCategoryUseful = category.getName() != null || category.getHot() != null;
                if (isCategoryUseful) {
                    logger.info("verifyUpdateAdmin: category verified.");
                    return category;
                }
            } else {
                logger.info("verifyUpdateAdmin: category.id not exist.");
            }
        } else {
            logger.info("verifyUpdateAdmin: category.id is null.");
        }
        return null;
    }
}
