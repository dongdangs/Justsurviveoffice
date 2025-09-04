package com.spring.app.board.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReportDTO {

	 private int reportNo;          // 신고 번호 (PK)
    private String fk_id;          // 신고자 ID
    private int fk_boardNo;        // 신고한 게시글 번호
    private String reportReason;   // 신고 사유
    private int reportStatus;      // 신고 상태 (0: 미처리, 1: 처리됨)
    private Date createdAtReport;  // 신고 일시
	
}
