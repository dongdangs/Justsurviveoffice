package com.spring.app.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.safety.Safelist;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.comment.model.CommentDAO;
import com.spring.app.common.FileManager;
import com.spring.app.users.domain.CommentDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService_imple implements BoardService {

    private final BoardDAO boardDao;
    private final FileManager fileManager;
    private final CommentDAO commentDao;
	
    // 게시글 업로드 메소드
	@Override
	@Transactional(value="transactionManager_final_orauser2",
	   propagation=Propagation.REQUIRED, 
	   isolation=Isolation.READ_COMMITTED, 
	   rollbackFor = {Throwable.class})
	public int insertBoard(BoardDTO boardDto) {
		
		int result = 0;
		
		if(boardDto.getBoardFileName() == null ||
			"".equals(boardDto.getBoardFileName())) {
			// 파일첨부 안 된 경우.
			result = boardDao.insertBoard(boardDto);
		}
		else {
			// 파일첨부 된 경우.
			result = boardDao.insertBoardWithFile(boardDto);
		}
		return result;
	}

	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> boardList(Map<String, String> paraMap) {
		
		List<BoardDTO> boardList = boardDao.selectBoardList(paraMap);
		
		for(BoardDTO dto : boardList) {
			// 1. 텍스트 변환
			String textForBoardList = Jsoup.clean(dto.getBoardContent()
					.replaceAll("(?i)<br\\s*/?>", "\n")	// 대소문자 구분 없이, <br>, <br/>, <br >, <BR/> 같은 줄바꿈 태그를 전부 찾기, 및 공백 변환
					.replace("&nbsp;", " "), Safelist.none());
			dto.setTextForBoardList(textForBoardList.length() > 20
									? textForBoardList.substring(0,20) + "..."
									: textForBoardList);

			// 2. 이미지 체크 및 추출
			Element img = Jsoup.parse(dto.getBoardContent()).selectFirst("img[src]");	// import org.jsoup.nodes.Element;
			if (img != null) {
				String imgForBoardList = img.attr("src");
				dto.setImgForBoardList(imgForBoardList);
				System.out.println("스마트에디터이미지는 경로 >> " +imgForBoardList);
				System.out.println("첨부이미지는 경로 >> " +dto.getBoardFileName());
			}
		}
		//이렇게 하지않으면, JSP가 HTML 스마트 에디터의 태그까지 문자열로 찍어주기 때문에 레이아웃이 깨짐!

		return boardList;
	}

	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@Override
	public BoardDTO selectView(Long boardNo) {

		BoardDTO boardDto = boardDao.selectView(boardNo);
		
		return boardDto;
	}

	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@Override
	public int deleteBoard(Long boardNo) {
		
		int n = boardDao.softDeleteBoard(boardNo);
		
		return n;
	}

	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	@Override
	public int updateReadCount(Long boardNo) {
		
		int n = boardDao.updateReadCount(boardNo);

		return n;
	}


	 //내가 작성한 글 목록
    @Override
    public List<BoardDTO> getMyBoards(String fkId) {
        return boardDao.getMyBoards(fkId);
    }

    // 북마크한 글 목록
    @Override
    public List<BoardDTO> getBookmarksById(String fkId) {
        return boardDao.getBookmarksById(fkId);
    }

    
    // 댓글목록
	@Override
	public List<CommentDTO> getCommentList(Long boardNo) {
	    return commentDao.getCommentList(boardNo);
	}

	
	//게시글 좋아요 여부
	@Override
	public boolean isBoardLiked(Long boardNo, String fkId) {
		 
		Map<String, Object> boardLike = new HashMap<>();
		
		boardLike.put("fkId", fkId);
		boardLike.put("boardNo", boardNo);
		return false;
		
	}

	@Override
	public void deleteBoardLike(Long boardNo, String id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertBoardLike(Long boardNo, String id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int getBaordLikeCount(Long boardNo) {
		return boardDao.getLikeCount(boardNo);
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = boardDao.getTopBoardsByViewCount();
		return hotReadList;
	}
	
	
	// Hot 게시글 전체 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> hotAll() {
		List<BoardDTO> hotAllList = boardDao.hotAll();
		return hotAllList;
	}
	
	
	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = boardDao.getTopBoardsByCommentCount();
		return hotCommentList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////   
	
	
	// 게시물 좋아요
	@Override
	public void boardLike(String fk_id, Long fk_boardNo) {
		boardDao.boardLike(fk_id, fk_boardNo);
	}
	
}




