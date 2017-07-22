namespace :assessment_questions_delete_task do
	desc "Assessment Question delete job"
	task :delete_task => :environment do
		AssessmentQuestion.where("id = 603").destroy_all

		# delete task fro experience-- start
		AssessmentQuestion.where("id = 129").destroy_all
		AssessmentQuestion.where("id = 131").destroy_all
		AssessmentQuestion.where("id = 137").destroy_all
		AssessmentQuestion.where("id = 588").destroy_all
		AssessmentQuestion.where("id = 125").destroy_all
		AssessmentQuestion.where("id = 583").destroy_all
		AssessmentQuestion.where("id = 586").destroy_all
		AssessmentQuestion.where("id = 585").destroy_all
		AssessmentQuestion.where("id = 587").destroy_all
		AssessmentQuestion.where("id = 589").destroy_all
		AssessmentQuestion.where("id = 591").destroy_all
		AssessmentQuestion.where("id = 561").destroy_all
		AssessmentQuestion.where("id = 562").destroy_all
		AssessmentQuestion.where("id = 108").destroy_all
		AssessmentQuestion.where("id = 135").destroy_all
		AssessmentQuestion.where("id = 110").destroy_all
		AssessmentQuestion.where("id = 112").destroy_all
		AssessmentQuestion.where("id = 117").destroy_all
		AssessmentQuestion.where("id = 114").destroy_all
		AssessmentQuestion.where("id = 116").destroy_all
		AssessmentQuestion.where("id = 118").destroy_all
		AssessmentQuestion.where("id = 121").destroy_all
		AssessmentQuestion.where("id = 120").destroy_all
		AssessmentQuestion.where("id = 109").destroy_all
		AssessmentQuestion.where("id = 668").destroy_all
		AssessmentQuestion.where("id = 669").destroy_all
		AssessmentQuestion.where("id = 670").destroy_all
		AssessmentQuestion.where("id = 671").destroy_all
		AssessmentQuestion.where("id = 672").destroy_all
		AssessmentQuestion.where("id = 673").destroy_all
		AssessmentQuestion.where("id = 674").destroy_all
		AssessmentQuestion.where("id = 675").destroy_all
		AssessmentQuestion.where("id = 676").destroy_all
		AssessmentQuestion.where("id = 677").destroy_all
		AssessmentQuestion.where("id = 115").destroy_all
		AssessmentQuestion.where("id = 119").destroy_all
		AssessmentQuestion.where("id = 678").destroy_all
		AssessmentQuestion.where("id = 679").destroy_all
		AssessmentQuestion.where("id = 680").destroy_all
		# delete task fro experience-- end

		# delete task fro spoken language-- start
		AssessmentQuestion.where("id = 499").destroy_all
		# delete task fro spoken language-- end

		# delete task for Housing sub section-- start
		AssessmentSubSection.where("id = 16").destroy_all
		# delete task for Housing sub section-- end

		# delete task for Transportation-- start
		AssessmentSubSection.where("id = 40").destroy_all
		# delete task for Transportation-- end

		# delete task for health-- start
		AssessmentSubSection.where("id = 28").destroy_all
		AssessmentQuestion.where("id = 496").destroy_all
		# delete task for health-- end

		# delete task for mental health-- start
		AssessmentSubSection.where("id = 34").destroy_all
		AssessmentQuestion.where("id = 172").destroy_all
		AssessmentQuestion.where("id = 174").destroy_all
		AssessmentQuestion.where("id = 175").destroy_all
		AssessmentQuestion.where("id = 683").destroy_all
		AssessmentQuestion.where("id = 684").destroy_all
		AssessmentQuestion.where("id = 254").destroy_all
		AssessmentQuestion.where("id = 255").destroy_all
		AssessmentQuestion.where("id = 256").destroy_all
		AssessmentQuestion.where("id = 257").destroy_all
		AssessmentQuestion.where("id = 258").destroy_all
		AssessmentQuestion.where("id = 259").destroy_all
		AssessmentQuestion.where("id = 260").destroy_all
		AssessmentQuestion.where("id = 261").destroy_all
		AssessmentQuestion.where("id = 262").destroy_all
		AssessmentQuestion.where("id = 263").destroy_all
		AssessmentQuestion.where("id = 264").destroy_all
		AssessmentQuestion.where("id = 265").destroy_all
		AssessmentQuestion.where("id = 475").destroy_all
		AssessmentQuestion.where("id = 476").destroy_all
		AssessmentQuestion.where("id = 477").destroy_all
		AssessmentQuestion.where("id = 478").destroy_all
		AssessmentQuestion.where("id = 479").destroy_all
		AssessmentQuestion.where("id = 480").destroy_all
		AssessmentQuestion.where("id = 482").destroy_all
		AssessmentQuestion.where("id = 483").destroy_all
		AssessmentQuestion.where("id = 484").destroy_all
		AssessmentQuestion.where("id = 485").destroy_all
		AssessmentQuestion.where("id = 486").destroy_all
		AssessmentQuestion.where("id = 487").destroy_all
		AssessmentQuestion.where("id = 488").destroy_all
		AssessmentQuestion.where("id = 489").destroy_all
		AssessmentQuestion.where("id = 490").destroy_all
		AssessmentQuestion.where("id = 491").destroy_all
		AssessmentQuestion.where("id = 492").destroy_all
		AssessmentQuestion.where("id = 253").destroy_all
		AssessmentQuestion.where("id = 249").destroy_all
		AssessmentQuestion.where("id = 251").destroy_all
		AssessmentQuestion.where("id = 252").destroy_all
		AssessmentQuestion.where("id = 481").destroy_all
		AssessmentQuestion.where("id = 250").destroy_all
		# delete task for mental health-- end

		# delete task for substance abuse sub section-- start
		AssessmentSubSection.where("id = 31").destroy_all
		AssessmentQuestion.where("id = 809").destroy_all
		AssessmentQuestion.where("id = 806").destroy_all
		AssessmentQuestion.where("id = 706").destroy_all
		# delete task for substance abuse sub section-- end

		# delete task for domestic violence-- start
		AssessmentSubSection.where("id = 37").destroy_all
		AssessmentQuestion.where("id = 540").destroy_all
		AssessmentQuestion.where("id = 539").destroy_all
		AssessmentQuestion.where("id = 77").destroy_all
		AssessmentQuestion.where("id = 78").destroy_all
		AssessmentQuestion.where("id = 522").destroy_all
		AssessmentQuestion.where("id = 523").destroy_all
		# delete task for domestic violence-- end

		# delete task for PREGNANCY-- start
		AssessmentSubSection.where("id = 18").destroy_all
		# delete task for PREGNANCY-- end

		# delete task for CHILDREN ISSUES-- start
		AssessmentSubSection.where("id = 20").destroy_all
		AssessmentQuestion.where("id = 365").destroy_all
		AssessmentQuestion.where("id = 291").destroy_all
		AssessmentQuestion.where("id = 369").destroy_all
		AssessmentQuestion.where("id = 370").destroy_all
		AssessmentQuestion.where("id = 371").destroy_all
		AssessmentQuestion.where("id = 372").destroy_all
		AssessmentQuestion.where("id = 373").destroy_all
		AssessmentQuestion.where("id = 374").destroy_all
		AssessmentQuestion.where("id = 375").destroy_all
		AssessmentQuestion.where("id = 376").destroy_all
		AssessmentQuestion.where("id = 377").destroy_all
		AssessmentQuestion.where("id = 378").destroy_all
		AssessmentQuestion.where("id = 379").destroy_all
		AssessmentQuestion.where("id = 380").destroy_all
		AssessmentQuestion.where("id = 381").destroy_all
		AssessmentQuestion.where("id = 382").destroy_all
		AssessmentQuestion.where("id = 383").destroy_all
		AssessmentQuestion.where("id = 384").destroy_all
		AssessmentQuestion.where("id = 385").destroy_all
		AssessmentQuestion.where("id = 386").destroy_all
		AssessmentQuestion.where("id = 472").destroy_all
		AssessmentQuestion.where("id = 493").destroy_all
		AssessmentQuestion.where("id = 494").destroy_all
		AssessmentQuestion.where("id = 267").destroy_all
		AssessmentQuestion.where("id = 268").destroy_all
		AssessmentQuestion.where("id = 269").destroy_all
		AssessmentQuestion.where("id = 270").destroy_all
		AssessmentQuestion.where("id = 271").destroy_all
		AssessmentQuestion.where("id = 272").destroy_all
		AssessmentQuestion.where("id = 273").destroy_all
		AssessmentQuestion.where("id = 274").destroy_all
		AssessmentQuestion.where("id = 275").destroy_all
		AssessmentQuestion.where("id = 276").destroy_all
		AssessmentQuestion.where("id = 277").destroy_all
		AssessmentQuestion.where("id = 278").destroy_all
		AssessmentQuestion.where("id = 279").destroy_all
		AssessmentQuestion.where("id = 280").destroy_all
		AssessmentQuestion.where("id = 281").destroy_all
		AssessmentQuestion.where("id = 282").destroy_all
		AssessmentQuestion.where("id = 283").destroy_all
		AssessmentQuestion.where("id = 284").destroy_all
		AssessmentQuestion.where("id = 285").destroy_all
		AssessmentQuestion.where("id = 286").destroy_all
		AssessmentQuestion.where("id = 287").destroy_all
		AssessmentQuestion.where("id = 288").destroy_all
		AssessmentQuestion.where("id = 289").destroy_all
		AssessmentQuestion.where("id = 292").destroy_all
		AssessmentQuestion.where("id = 293").destroy_all
		AssessmentQuestion.where("id = 294").destroy_all
		AssessmentQuestion.where("id = 295").destroy_all
		AssessmentQuestion.where("id = 296").destroy_all
		AssessmentQuestion.where("id = 297").destroy_all
		AssessmentQuestion.where("id = 298").destroy_all
		AssessmentQuestion.where("id = 299").destroy_all
		AssessmentQuestion.where("id = 300").destroy_all
		AssessmentQuestion.where("id = 301").destroy_all
		AssessmentQuestion.where("id = 302").destroy_all
		AssessmentQuestion.where("id = 303").destroy_all
		AssessmentQuestion.where("id = 304").destroy_all
		AssessmentQuestion.where("id = 305").destroy_all
		AssessmentQuestion.where("id = 306").destroy_all
		AssessmentQuestion.where("id = 307").destroy_all
		AssessmentQuestion.where("id = 308").destroy_all
		AssessmentQuestion.where("id = 309").destroy_all
		AssessmentQuestion.where("id = 310").destroy_all
		AssessmentQuestion.where("id = 311").destroy_all
		AssessmentQuestion.where("id = 312").destroy_all
		AssessmentQuestion.where("id = 313").destroy_all
		AssessmentQuestion.where("id = 314").destroy_all
		AssessmentQuestion.where("id = 315").destroy_all
		AssessmentQuestion.where("id = 316").destroy_all
		AssessmentQuestion.where("id = 317").destroy_all
		AssessmentQuestion.where("id = 318").destroy_all
		AssessmentQuestion.where("id = 319").destroy_all
		AssessmentQuestion.where("id = 320").destroy_all
		AssessmentQuestion.where("id = 321").destroy_all
		AssessmentQuestion.where("id = 322").destroy_all
		AssessmentQuestion.where("id = 323").destroy_all
		AssessmentQuestion.where("id = 324").destroy_all
		AssessmentQuestion.where("id = 325").destroy_all
		AssessmentQuestion.where("id = 326").destroy_all
		AssessmentQuestion.where("id = 327").destroy_all
		AssessmentQuestion.where("id = 328").destroy_all
		AssessmentQuestion.where("id = 329").destroy_all
		AssessmentQuestion.where("id = 330").destroy_all
		AssessmentQuestion.where("id = 331").destroy_all
		AssessmentQuestion.where("id = 332").destroy_all
		AssessmentQuestion.where("id = 333").destroy_all
		AssessmentQuestion.where("id = 334").destroy_all
		AssessmentQuestion.where("id = 335").destroy_all
		AssessmentQuestion.where("id = 336").destroy_all
		AssessmentQuestion.where("id = 337").destroy_all
		AssessmentQuestion.where("id = 338").destroy_all
		AssessmentQuestion.where("id = 339").destroy_all
		AssessmentQuestion.where("id = 340").destroy_all
		AssessmentQuestion.where("id = 341").destroy_all
		AssessmentQuestion.where("id = 342").destroy_all
		AssessmentQuestion.where("id = 343").destroy_all
		AssessmentQuestion.where("id = 344").destroy_all
		AssessmentQuestion.where("id = 345").destroy_all
		AssessmentQuestion.where("id = 346").destroy_all
		AssessmentQuestion.where("id = 347").destroy_all
		AssessmentQuestion.where("id = 348").destroy_all
		AssessmentQuestion.where("id = 349").destroy_all
		AssessmentQuestion.where("id = 350").destroy_all
		AssessmentQuestion.where("id = 351").destroy_all
		AssessmentQuestion.where("id = 352").destroy_all
		AssessmentQuestion.where("id = 353").destroy_all
		AssessmentQuestion.where("id = 354").destroy_all
		AssessmentQuestion.where("id = 355").destroy_all
		AssessmentQuestion.where("id = 356").destroy_all
		AssessmentQuestion.where("id = 357").destroy_all
		AssessmentQuestion.where("id = 358").destroy_all
		AssessmentQuestion.where("id = 359").destroy_all
		AssessmentQuestion.where("id = 360").destroy_all
		AssessmentQuestion.where("id = 361").destroy_all
		AssessmentQuestion.where("id = 362").destroy_all
		AssessmentQuestion.where("id = 363").destroy_all
		AssessmentQuestion.where("id = 364").destroy_all
		AssessmentQuestion.where("id = 290").destroy_all
		AssessmentQuestion.where("id = 366").destroy_all
		AssessmentQuestion.where("id = 367").destroy_all
		AssessmentQuestion.where("id = 368").destroy_all
		AssessmentQuestion.where("id = 639").destroy_all
		AssessmentQuestion.where("id = 631").destroy_all
		AssessmentQuestion.where("id = 632").destroy_all
		AssessmentQuestion.where("id = 633").destroy_all
		AssessmentQuestion.where("id = 634").destroy_all
		AssessmentQuestion.where("id = 635").destroy_all
		AssessmentQuestion.where("id = 636").destroy_all
		AssessmentQuestion.where("id = 637").destroy_all
		AssessmentQuestion.where("id = 638").destroy_all
		AssessmentQuestion.where("id = 640").destroy_all
		AssessmentQuestion.where("id = 641").destroy_all
		# delete task for CHILDREN ISSUES-- end

		# delete task for PARENTAL AND CHILD SUPPORT-- start
		AssessmentQuestion.where("id = 685").destroy_all
		AssessmentQuestion.where("id = 686").destroy_all
		AssessmentQuestion.where("id = 572").destroy_all
		AssessmentQuestion.where("id = 573").destroy_all
		# delete task for PARENTAL AND CHILD SUPPORT-- end

		# delete task for Backup childcare-- start
		AssessmentQuestion.where("id = 524").destroy_all
		AssessmentQuestion.where("id = 525").destroy_all
		# delete task for Backup childcare-- end


		# delete task for relationships-- start
		AssessmentSubSection.where("id = 44").destroy_all
		# delete task for relationships-- end


		# delete task for Childcare Status-- start
		AssessmentQuestion.where("id = 458").destroy_all
		AssessmentQuestion.where("id = 455").destroy_all
		AssessmentQuestion.where("id = 456").destroy_all
		AssessmentQuestion.where("id = 457").destroy_all
		AssessmentQuestion.where("id = 459").destroy_all
		AssessmentQuestion.where("id = 460").destroy_all
		AssessmentQuestion.where("id = 461").destroy_all
		AssessmentQuestion.where("id = 462").destroy_all
		AssessmentQuestion.where("id = 463").destroy_all
		AssessmentQuestion.where("id = 464").destroy_all
		AssessmentQuestion.where("id = 465").destroy_all
		AssessmentQuestion.where("id = 466").destroy_all
		AssessmentQuestion.where("id = 467").destroy_all
		AssessmentQuestion.where("id = 468").destroy_all
		AssessmentQuestion.where("id = 469").destroy_all
		AssessmentQuestion.where("id = 470").destroy_all
		# delete task for Childcare Status-- end

		#delete from general health--start
		AssessmentQuestion.where("id = 516").destroy_all
		AssessmentQuestion.where("id = 65").destroy_all
		#delete from general health--end

    end
end