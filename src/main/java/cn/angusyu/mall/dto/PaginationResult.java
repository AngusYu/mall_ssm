package cn.angusyu.mall.dto;

import java.util.List;

/**
 * @author AngusYu
 */
public class PaginationResult {
    private Long total;
    private List<?> rows;

    public PaginationResult(Long total, List<?> rows) {
        this.total = total;
        this.rows = rows;
    }

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public List<?> getRows() {
        return rows;
    }

    public void setRows(List<?> rows) {
        this.rows = rows;
    }

    @Override
    public String toString() {
        return "PaginationResult{" +
                "total=" + total +
                ", rows=" + rows +
                '}';
    }
}
