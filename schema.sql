DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(128) NOT NULL,
  `title` varchar(128) NOT NULL,
  `contents` text NOT NULL,
  `code` text NOT NULL,
  `embed` text NOT NULL,
  `file` varchar(128) NOT NULL,
  `link` varchar(255) NOT NULL,
  `byline` varchar(128) NOT NULL,
  `tags` varchar(255) NOT NULL,
  `type` varchar(24) NOT NULL,
  `posted_on` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `user` varchar(128) NOT NULL,
  `contents` text NOT NULL,
  `posted_on` datetime NOT NULL,
  PRIMARY KEY (`id`)
);