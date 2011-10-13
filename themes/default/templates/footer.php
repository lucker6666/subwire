
		<? if(isset($pagination)): ?>
			<ul id="pagination">
				<? if(!isset($post)): ?>
					<? if($pages > $page): ?>
					<li class="previous"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?page=<?=floor($page+1)?>">&laquo; Older</a></li>
					<? else: ?>
					<li class="previous_off">&laquo; Older</li>
					<? endif ?>
					<? if($page == 1): ?>
					<li class="next_off">Newer &raquo;</li>
					<? else: ?>
					<li class="next"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?page=<?=floor($page-1)?>">Newer &raquo;</a></li>
					<? endif ?>
				<? else: ?>
					<? if($prev_post !== null): ?>
						<li class="previous"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?=$prev_post?>">&laquo; Previous Post</a></li>
					<? else: ?>
						<li class="previous_off">&laquo; Previous Post</li>
					<? endif ?>
					<? if($next_post !== null): ?>
						<li class="next"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?=$next_post?>">Next Post &raquo</a></li>
					<? else: ?>
						<li class="next_off">Next Post &raquo;</li>
					<? endif ?>
				<? endif ?>
			</ul>
        <? endif ?>

        <footer>
            <a target="_blank" href="http://github.com/itws/Brain-Dump">Powered by Brain Dump</a> | <a href="<?=rtrim(SITE_URL, '/')?>/feed.php">RSS</a>
        </footer>
    </div>
</body>
</html>

