1.Filewebsite rsync si OK > website file juga harus di rsync (pake LB/manual bth rsync) (Fokusnya pada lp jagoanhosting no blok dll)
2.Perlu di coba untuk sync db, bisa dilakukan scripting untuk import export, scr manual sysc DB tidak bisa dari rsyn, 
tidak bisa menimpa timpa DB, maka harus ada solusi agar di server backup DB ttp bs sync dg utama,

Perlu validasi document file manager di maximus LP yg tidak di gunakan
3.Cari solusi untuk propagation DNS (maximus pake DNS Cloudflare), untuk cari saat ini dilakukan manual, lain misal wordpress tool transfer atau sofcolous utk dns propagation  
4.Tidak harus di server singapura untuk backup nya
5.Terkait update content > Post dll dalam web wordpress > Bisdev
	Untuk config penambahan 


Solusi manual dg server clone 
1.Rsync data website/clone > use migrate guru plugin (you’re limited to 5 site migrations per month. You can move these 5 sites unlimited times)
				 NS Cloner > identical site with the same theme settings, plugins, and content.
Untuk sync data stlh running bs gunakan wp-data-sync https://wordpress.org/plugins/wp-data-sync/ (Berbayar)
2.DB Sync https://www.hongkiat.com/blog/sync-db-multiple-wordpress/


1.Clone website menggunakan transfer tool ke server baru (Sudah termasuk DB + Web)
2.Menggunakan Rsync data incremental (jalankan cronjob) untuk proses sync data Web LP
	Kelebihan dan kekurangan Rsync
	 - Data sync dilakukan secara otomatis dg menjalankan nya dg cronjob
	 - Akan membutuhkan effort untuk sysc DB untuk membuat script sysc (no replication DB)
	Menggunakan plugin https://wordpress.org/plugins/wpsitesynccontent/
		Fitur-firur wp site sync contenct (jadi plugin ini bisa langsung kita lakukan sync ketika ada update suatu post)
			In the Free Version, WPSiteSync for Contents synchronizes the following:

				Blog Post Text Content
				Page Text Content
				Content Images
				Featured Images
				Shortcodes referencing Galleries and Playlists
				PDF Attachments
				Meta-Data
				Taxonomies such as Tags and Categories
				Gutenberg Compatible. Create content with Gutenberg on Staging and Push it to Live, along with all images.
				And lots more
			
	Pushlive https://wordpress.org/plugins/pushlive/(Secara umum plugin ini bekerja ketika semua nya selesai melakukan update, baru editor harus sync dengan klik button pushlive, dan setiap melakukan sysnc menggunakan plugin ini otomatis juga ngebackup DB )
				Fast staging to live pushes that only update the new or changed content as necessary.
				Individual and Independent pushes for each site if using Multisite.
				Easy 1 page, top to bottom setup and configuration.
				A visible log of all previous pushes can be viewed on the main PushLive page.
				Require all users to log in to view the staging server
3.DNS load balancing dengan cloudflare, dg mekanisme pengecekan healty and unhealty DNS (Tapi saya bingung karna ini sekarang axisting menggunakan DNS Cluster is disable, apakah memungkinkan disetting untuk LB dicloudflare??)
4.Perlu adanya riset dan uji coba terkait langkah-langkah diatas dan ini pasti membutuhkan waktu untuk bisa implementasi prod

Opsi 1 Minggu ini :

1.Install plugin WPSiteSync di lp jagoanhosting.com production (Untuk sync data ketika ada update di prod)
2.Install plugin Migrate Guru di lp jagoanhosting.com production
3.Install wordpress pada server tujuan dengan catatan server yang tersetting disable DNS clusternya(Refrensi step 2-3 https://www.youtube.com/watch?v=GAV4600qEzg)
4.Setting DNS pada server backup

Opsi solusi lain :

