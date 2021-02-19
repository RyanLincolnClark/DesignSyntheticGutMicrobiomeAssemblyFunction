#Define the descriptors involved in this experiment
numspecies=25
allspecies=['ER','FP','AC','CC','RI','EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA']
phylogeny=['PC','PJ','BV','BF','BO','BT','BC','BY','BU','DP','BL','BA','BP','CA','EL','FP','CH','AC','BH','CG','ER','RI','CC','DL','DF']
phylogeny_nobpb=['PC','PJ','BV','BF','BO','BT','BC','BY','BU','DP','BL','BA','BP','CA','EL','CH','BH','CG','DL','DF']
phylogeny_nogaps=['PC','PJ','BF','BO','BT','DP','BA','BP','CA','EL','CH','BH','CG','DL','DF']
speciesvectorDict={}
n=1
for species in allspecies:
	speciesvectorDict[species]=n
	n+=1

k=0
phylogenyvectorDict={}
for species in phylogeny:
	phylogenyvectorDict[species]=k
	k+=1

bpbindices=[15,17,20,21,22]
bpbspecies=['ER','FP','AC','CC','RI']
spbspecies=['PJ','BT','BF','BC','BO','BV','PC']
others=['EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA']
comms=['COMM0','COMM1','COMM2','COMM3','COMM4']

commsDict={
	'COMM0':['DP','BH','CA','PC','EL','CH','BO','BT','BU','BV'],
	'COMM1':['ER','FP','DP','BH','CA','PC','EL','CH','BO','BT','BU','BV'],
	'COMM2':['ER','FP','AC','HB','CC','RI','DP','BH','CA','PC','EL','CH','BO','BT','BU','BV'],
	'COMM3':['ER','FP','AC','HB','CC','RI','EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA'],
	'COMM4':['EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA'],
	'COMM5':['ER','FP','AC','CC','RI','DP','BH','CA','PC','EL','CH','BO','BT','BU','BV'],
	'COMM6':['ER','FP','AC','CC','RI','EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA'],
	'COMM7':['ER','FP','RI','BH','DP','PJ','AC','CC','BV','DL','BY','BL','DF','BA','EL'],
	'COMM8':['ER','FP','RI','AC','CC']
}

COMM0=['DP','BH','CA','PC','EL','CH','BO','BT','BU','BV']
COMM1=['ER','FP','DP','BH','CA','PC','EL','CH','BO','BT','BU','BV']
COMM2=['ER','FP','AC','HB','CC','RI','DP','BH','CA','PC','EL','CH','BO','BT','BU','BV']
COMM3=['ER','FP','AC','HB','CC','RI','EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA']
COMM4=['EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA']
COMM5=['ER','FP','AC','CC','RI','DP','BH','CA','PC','EL','CH','BO','BT','BU','BV']
COMM6=['ER','FP','AC','CC','RI','EL','CH','DP','BH','CA','PC','PJ','DL','CG','BF','BO','BT','BU','BV','BC','BY','DF','BL','BP','BA']
COMM7=['ER','FP','RI','BH','DP','PJ','AC','CC','BV','DL','BY','BL','DF','BA','EL']
COMM8=['ER','FP','RI','AC','CC']

LOOComms=['COMM6']
for species in phylogeny:
	LOOComms.append('COMM6*'+species)

colordict = {
		'ER' : 'xkcd:pale purple',	#b790d4
		'DP' : 'xkcd:orange',		#f97306
		'FP' : 'xkcd:brick red',	#8f1402
		'BH' : 'xkcd:dark purple',	#35063e
		'CA' : 'xkcd:light orange',	#fdaa48
		'PC' : 'xkcd:light blue',	#95d0fc
		'EL' : 'xkcd:peach',		#ffb07c
		'CH' : 'xkcd:mauve',		#ae7181
		'BO' : 'xkcd:olive',		#6e750e
		'BT' : 'xkcd:green',		#15b01a
		'BU' : 'xkcd:blue green',	#137e6d
		'BV' : 'xkcd:blue',			#0343df
		'AC' : 'xkcd:periwinkle',	#8e82fe
		'HB' : 'xkcd:magenta',		#c20078
		'CC' : 'xkcd:grey',			#929591
		'RI' : 'xkcd:dark blue',	#00035b
		'DL' : 'xkcd:brown',		#653700
		'CG' : 'xkcd:purple',		#7e1e9c
		'BF' : 'xkcd:lime green',	#89fe05
		'BC' : 'xkcd:sea green',	#53fca1
		'BY' : 'xkcd:sage',			#87ae73
		'PJ' : 'xkcd:cyan',			#00ffff
		'DF' : 'xkcd:tan',			#d1b26f
		'BL' : 'xkcd:red',			#e50000
		'BP' : 'xkcd:salmon pink',	#ff796c
		'BA' : 'xkcd:coral',		#fc5a50
		'CD' : 'Black',
		'CS' : 'Black',
		'EH' : 'Black',
		'EC' : 'Black'
		}
		
namedict={
   'BA': 'Bifidobacterium_adolescentis_ATCC_15703_NC_008618',
   'CA': 'Collinsella_aerofaciens_ATCC_25986',
   'BT': 'Bacteroides_thetaiotaomicron_VPI-5482_NC_004663',
   'BU': 'Bacteroides_uniformis_ATCC_8492',
   'PC': 'Prevotella_copri_DSM_18205',
   'AC': 'Anaerostipes_caccae_DSM_14662_4',
   'BH': 'Blautia_hydrogenotrophica_DSM_10507',
   'CC': 'Coprococcus_comes_1.0.1_Cont2276_NZ_ABVR01000038',
   'CG': 'Clostridium_asparagiforme_DSM_15981_C_asparagiforme_1.0_Cont7.2_NZ_ACCJ01000522',
   'ER': 'Eubacterium_rectale_ATCC_33656_NC_012781',
   'DP': 'Desulfovibrio_piger_ATCC_29098',
   'EL': 'Eggerthella_lenta_DSM_2243_NC_013204',
   'BY': 'Bacteroides_cellulosilyticus_DSM_14838_1.0_Cont4.1_NZ_ACCH01000108',
   'BF': 'Bacteroides_fragilis_NCTC_9343',
   'CD': 'Clostridioides_difficile',
   'RI': 'Roseburia_intestinalis_L1_82',
   'BP': 'Bifidobacterium_pseudocatenulatum_DSM20438',
   'BV': 'Bacteroides_vulgatus_ATCC_8482_NC_009614',
   'CH': 'Clostridium_hiranonis_DSM_13275',
   'DF': 'Dorea_formicigenerans_ATCC_27755',
   'CS': 'Clostridium_scindens_ATCC_35704',
   'PJ': 'Parabacteroides_johnsonii_DSM_18315_NZ_ABYH01000014',
   'FP': 'Faecalibacterium_prausnitzii_A2_165_NZ',
   'EH': 'Eubacterium_hallii_DSM_3353_1.0_Cont383.1_NZ_ACEP01000116',
   'EC': 'Escherichia_coli',
   'BC': 'Bacteroides_caccae_ATCC_43185',
   'HB': 'Holdemanella_biformis_DSM_3989',
   'BO': 'Bacteroides_ovatus_ATCC_8483',
   'DL': 'Dorea_longicatena_DSM_13814',
   'BL': 'Bifidobacterium_longum_subsp_infantis',
   'B.cereus':'Bacillus_cereus'
   }

metabcolordict={'Acetate': 'r','Butyrate': 'b','Lactate': 'g','Succinate': 'k'}
pairslist=[]
for bpb in bpbspecies:
	for species in allspecies:
		if bpb!=species:
			if species in bpbspecies:
				order=sorted([species,bpb])
				pairslist.append(order[0]+'-'+order[1])
			else:
				pairslist.append(species+'-'+bpb)
pairslist=list(set(pairslist))

validationset_3=['BY-BH-ER','BV-BH-ER','BV-BA-ER','PJ-EL-FP','EL-FP-DF','BY-DP-FP','DP-BA-AC','BA-AC-DF','BY-DP-AC','BY-EL-CC','PJ-BA-CC','DP-BL-CC','DP-BH-RI','BY-BH-RI','BY-EL-RI','FP-BH-ER','DP-FP-ER','BV-FP-ER','BY-AC-ER','AC-ER-DL','AC-BH-ER','BY-ER-CC','BL-ER-CC','ER-CC-DL','BV-ER-RI','PJ-ER-RI','BH-ER-RI','BA-FP-AC','FP-AC-DF','BL-FP-AC','BY-FP-CC','PJ-FP-CC','BL-FP-CC','EL-FP-RI','BL-FP-RI','PJ-FP-RI','BA-AC-CC','PJ-AC-CC','BL-AC-CC','BA-AC-RI','AC-RI-DL','DP-AC-RI','DP-RI-CC','EL-RI-CC','RI-CC-DL','AC-RI-CC','AC-ER-CC','AC-ER-RI','ER-RI-CC','FP-AC-ER','FP-ER-CC','FP-ER-RI','FP-AC-CC','FP-AC-RI','FP-RI-CC']
validationset_4=['BV-BF-BA-ER', 'BY-CH-CG-ER', 'BV-BC-FP-ER', 'BY-CA-FP-ER', 'DP-AC-ER-DF', 'AC-CG-ER-DL', 'BV-BT-ER-CC', 'BH-CG-ER-CC', 'BV-BC-ER-RI', 'BH-ER-RI-DF', 'BY-BA-CA-FP', 'PJ-BU-FP-DL', 'BV-BC-FP-AC', 'DP-BA-FP-AC', 'BT-BL-FP-CC', 'PJ-BY-FP-CC', 'BV-BC-FP-RI', 'FP-CH-BH-RI', 'AC-BH-CG-DF', 'BA-CH-AC-BH', 'BF-BL-AC-CC', 'BY-AC-CG-CC', 'BA-BP-AC-RI', 'CH-AC-CG-RI', 'BF-BT-BL-CC', 'BY-CA-BH-CC', 'BF-BT-RI-CC', 'BY-DP-RI-CC', 'BU-CA-EL-RI', 'PC-CH-BH-RI', 'DP-FP-AC-ER', 'FP-AC-CG-ER', 'BC-FP-ER-CC', 'FP-CG-ER-CC', 'BC-FP-ER-RI', 'BY-FP-ER-RI', 'BL-AC-ER-CC', 'AC-CG-ER-CC', 'AC-BH-ER-RI', 'BA-AC-ER-RI', 'BC-ER-RI-CC', 'CG-ER-RI-CC', 'BF-FP-AC-CC', 'BA-FP-AC-CC', 'FP-AC-BH-RI', 'BA-FP-AC-RI', 'BF-FP-RI-CC', 'FP-BH-RI-CC', 'BL-AC-RI-CC', 'DP-AC-RI-CC']
validationset_5=['BV-BF-BA-EL-ER', 'BY-CA-BH-CG-ER', 'BV-BT-BC-FP-ER', 'BY-BU-FP-ER-DF', 'DP-FP-AC-ER-DF', 'BY-FP-AC-CG-ER', 'BV-BT-FP-ER-CC', 'FP-BH-CG-ER-CC', 'BV-BC-FP-ER-RI', 'BY-FP-CH-ER-RI', 'DP-AC-BH-ER-DF', 'BA-AC-CG-ER-DL', 'BL-AC-ER-CC-DF', 'AC-CG-ER-CC-DL', 'CA-AC-ER-RI-DF', 'BY-AC-CG-ER-RI', 'BV-BF-BT-ER-CC', 'BY-CH-CG-ER-CC', 'BV-BT-ER-RI-CC', 'BH-CG-ER-RI-CC', 'BV-BT-BC-ER-RI', 'BY-BU-BH-ER-RI', 'BY-BL-BA-BP-FP', 'PJ-BU-FP-CH-DF', 'BV-BF-FP-AC-DL', 'BA-FP-CH-AC-BH', 'BF-BL-FP-AC-CC', 'BY-BA-FP-AC-CC', 'FP-CH-AC-BH-RI', 'BA-EL-FP-AC-RI', 'BF-BT-BL-FP-CC', 'BY-FP-CH-BH-CC', 'BF-BT-FP-RI-CC', 'FP-CH-BH-RI-CC', 'BV-BA-BP-FP-RI', 'PC-FP-CH-BH-RI', 'AC-BH-CG-DL-DF', 'BA-CA-CH-AC-BH', 'BF-BT-BL-AC-CC', 'BO-BA-AC-CG-CC', 'BT-BL-AC-RI-CC', 'PJ-AC-CG-RI-CC', 'PJ-BA-BP-AC-RI', 'PC-CH-AC-BH-RI', 'BF-BT-BL-BA-CC', 'BY-EL-CH-BH-CC', 'BF-BT-BC-RI-CC', 'BY-DP-CH-RI-CC', 'BV-BF-BT-RI-DL', 'BU-DP-CH-BH-RI', 'BT-FP-AC-ER-CC', 'FP-AC-CG-ER-CC', 'BL-FP-AC-ER-RI', 'FP-AC-CG-ER-RI', 'BC-FP-ER-RI-CC', 'FP-BH-ER-RI-CC', 'BT-AC-ER-RI-CC', 'AC-CG-ER-RI-CC', 'BT-FP-AC-RI-CC', 'DP-FP-AC-RI-CC']