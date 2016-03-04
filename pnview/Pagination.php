<?php
class Pagination {
	function getStartRow($page,$limit){
		$startrow = $page * $limit - ($limit);
		return $startrow;
	}	
	function showPageNumbers($totalrows,$page,$limit){
	
		$query_string = $this->queryString();
	
		$pagination_links = null;
	
		$numofpages = $totalrows / $limit; 
		for($i = 1; $i <= $numofpages; $i++){
		  if($i == $page){
				$pagination_links .= '<div class="page-link"><span>'.$i.'</span></div> ';
			}else{ 
				$pagination_links .= '<div class="page-link"><a href="?page='.$i.'&'.$query_string.'">'.$i.'</a></div> '; 
			}
		}
		
		if(($totalrows % $limit) != 0){
			if($i == $page){
				$pagination_links .= '<div class="page-link"><span>'.$i.'</span></div> ';
			}else{
				$pagination_links .= '<div class="page-link"><a href="?page='.$i.'&'.$query_string.'">'.$i.'</a></div> ';
			}
		}
	
		return $pagination_links;
	}

	function showNext($totalrows,$page,$limit,$text="next &raquo;"){	
		$query_string = $this->queryString();
		$next_link = null;
		$numofpages = $totalrows / $limit;
		
		if($page < $numofpages){
			$page++;
			$next_link = '<div class="page-link"><a href="?page='.$page.'&'.$query_string.'">'.$text.'</a></div>';
		}
		
		return $next_link;
	}
	
    function showPrev($totalrows,$page,$limit,$text="&laquo; prev"){
		$query_string = $this->queryString();
        $next_link = null;
        $prev_link = null;
		$numofpages = $totalrows / $limit;
		
		if($page > 1){
			$page--;
			$prev_link = '<div class="page-link"><a href="?page='.$page.'&'.$query_string.'">'.$text.'</a></div>';
		}
		
		return $prev_link;
	}
	
	function queryString(){	
		$query_string = preg_replace("/page=[0-9]{0,10}&/","",$_SERVER['QUERY_STRING']);
		return $query_string;
	}
} 
?>
