' LifeSim 1.0
' Copyright (C) TME/WTR - 2004/2007
' Contact : tme@mail.com
' 
' Ce programme est libre, vous pouvez le redistribuer et/ou le modifier selon les termes de la Licence Publique Générale GNU publiée par la Free Software Foundation (version 2 ou bien toute autre version ultérieure choisie par vous).
' 
' Ce programme est distribué car potentiellement utile, mais SANS AUCUNE GARANTIE, ni explicite ni implicite, y compris les garanties de commercialisation ou d' adaptation dans un but spécifique. Reportez-vous à la Licence Publique Générale GNU pour plus de détails.
' 
' Vous devez avoir reçu une copie de la Licence Publique Générale GNU en même temps que ce programme ; si ce n'est pas le cas, écrivez à la Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, États-Unis. 


' Ouverture d'un ecran en 640*480 en couleurs 32 bits
Graphics 640,480,32
' Masquage du pointeur de souris
HideMouse()
' Initialisation des caracteristiques de l'affichage
SetBlend ALPHABLEND
SetAlpha 1.0

'  Déclaration des tableaux
' Creation du tableau contenant les infos sur les cellules
Global cellules[57,24]
' Creation de la copie du tableau contenant les infos sur les cellules
Global cellules_copie[57,24]
' Déclaration et initialisation des entiers
Global iComptVoisins:Int=0
Global iComptBoucles:Long=1
Global iCompteurX:Int=0
Global iCompteurY:Int=0
Global iModeRendu:Short=1

Const VERSION:String="1.1.0 - 04/08/2007"

WriteStdout("      <VAR OK>      ")

' Appel de la fonction d'initialisation de la simulation
initSim()

' Boucle principale du programme
While Not KeyHit(KEY_ESCAPE)
	WriteStdout("      <MAIN LOOP TOP OK>      ")

    ' Si on appuie sur le barre d'espace, la simulation repart de zéro
    If KeyHit(KEY_SPACE)
		iComptBoucles=0
		initSim()
	EndIf
	
	' Si on appuie sur un des chiffres du pavé machine
	' le mode de rendu change
	If KeyHit(KEY_1) Then
		' Mode classique : Grille verte et cellules colorées
		iModeRendu=1
	Else
		If KeyHit(KEY_2) Then
			' Mode binaire : Uniquement des 0 et des 1
			iModeRendu=2
		EndIf
	EndIf

    ' Debut du code de la simulation
    For iCompteurX=0 To 56 Step 1
		For iCompteurY=0 To 23 Step 1
        	iComptVoisins=0
			If iCompteurX>0
				If iCompteurY>0
					' HAUT-GAUCHE
					If cellules[iCompteurX-1,iCompteurY-1]=1
						iComptVoisins=iComptVoisins+1
					EndIf
					' HAUT
					If cellules[iCompteurX,iCompteurY-1]=1
						iComptVoisins=iComptVoisins+1
					EndIf
				EndIf
				' GAUCHE
				If cellules[iCompteurX-1,iCompteurY]=1
					iComptVoisins=iComptVoisins+1
				EndIf
				If iCompteurY<23
					' BAS-GAUCHE
					If cellules[iCompteurX-1,iCompteurY+1]=1
						iComptVoisins=iComptVoisins+1
					EndIf
					' BAS
					If cellules[iCompteurX,iCompteurY+1]=1
						iComptVoisins=iComptVoisins+1
					EndIf
				EndIf
			EndIf
			If iCompteurX<56
				If iCompteurY>0
 					' HAUT-DROITE
					If cellules[iCompteurX+1,iCompteurY-1]=1
						iComptVoisins=iComptVoisins+1
					EndIf
				EndIf
				' DROITE
				If cellules[iCompteurX+1,iCompteurY]=1
					iComptVoisins=iComptVoisins+1
				EndIf
				' BAS-DROITE
				If iCompteurY<23
					If cellules[iCompteurX+1,iCompteurY+1]=1
						iComptVoisins=iComptVoisins+1
					EndIf
				EndIf
			EndIf
			' Détermination de la naissance ou de la mort des cellules
			If (iComptVoisins<2) Or (iComptVoisins>3)
				cellules_copie[iCompteurX,iCompteurY]=0
			Else
				If iComptVoisins=3
					cellules_copie[iCompteurX,iCompteurY]=1
				EndIf
			EndIf
		Next
	Next
	' Mise à jour du tableau principal avec les données contenues dans le tableau brouillon
    For iCompteurX=0 To 56 Step 1
		For iCompteurY=0 To 23 Step 1
			cellules[iCompteurX,iCompteurY]=cellules_copie[iCompteurX,iCompteurY]
		Next
    Next
	iComptBoucles=iComptBoucles+1
	' Mise à jour de l'affichage
	Cls
	afficherTexte("== Version "+VERSION+" ==","blanc",1,10,270)
	afficherTexte("This life simulator uses John Horton Conway's algorithm.","blanc",1,10,290)
	afficherTexte("[ESC] to quit - [SPACE] to restart","blanc",1,10,310)
	afficherTexte("Mode de rendu : "+iModeRendu+" -- Generation number "+iComptBoucles,"blanc",1,10,330)
    demarrerRendu(iModeRendu)
	Delay 50
	Flip
    ' Fin du code de la simulation
	WriteStdout("      <MAIN LOOP BOTTOM OK>      ")
Wend

' On affiche de nouveau le pointeur de souris
ShowMouse()
' On ferme l'ecran
EndGraphics()

End

' =================== LES FONCTIONS ===================

Function initSim()
	WriteStdout("      <INITSIM IN>      ")
	Local iCompteurBouclesRemplissageX:Int=0
	Local iCompteurBouclesRemplissageY:Int=0
	SetColor 40,40,40
	' Remplissage aleatoire du tableau des cellules
	SeedRnd MilliSecs()
	For iCompteurBouclesRemplissageX=0 To 56 Step 1
		For iCompteurBouclesRemplissageY=0 To 23 Step 1
			cellules[iCompteurBouclesRemplissageX,iCompteurBouclesRemplissageY]=Rand(0,1)
	    Next
	Next
	Flip
	
	For iCompteurBouclesRemplissageX=0 To 56 Step 1
		For iCompteurBouclesRemplissageY=0 To 23 Step 1
			cellules_copie[iCompteurBouclesRemplissageX,iCompteurBouclesRemplissageY]=cellules[iCompteurBouclesRemplissageX,iCompteurBouclesRemplissageY]
	    Next
	Next
	demarrerRendu(1)
	WriteStdout("      <INITSIM OUT>      ")
End Function

Function demarrerRendu(modeDeRenduChoisi:Short)
	If modeDeRenduChoisi=1 Then
		' Premier mode de rendu
		traceTableau()
		refreshCells()
	Else
		If modeDeRenduChoisi=2 Then
			' Second mode de rendu
			afficheBinaire()
		EndIf
	EndIf
End Function

Function afficheBinaire()
	WriteStdout("      <AFFICHEBINAIRE IN>      ")
	For iCompteurBouclesRemplissageX=0 To 56 Step 1
		For iCompteurBouclesRemplissageY=0 To 23 Step 1
			afficherTexte(cellules[iCompteurBouclesRemplissageX,iCompteurBouclesRemplissageY],"blanc",1,(iCompteurBouclesRemplissageX*10)+10,(iCompteurBouclesRemplissageY*10)+20)
	    Next
	Next
	WriteStdout("      <AFFICHEBINAIRE OUT>      ")
End Function

Function refreshCells()
	WriteStdout("      <REFRESHCELLS IN>      ")
	Local iCompteurBouclesRetraceVert:Int=0
	Local iCompteurBouclesRetraceHoriz:Int=0
	' Remplissage des cellules
	For iCompteurBouclesRetraceVert=11 To 571 Step 10
		For iCompteurBouclesRetraceHoriz=21 To 251 Step 10
			If (cellules[Int((iCompteurBouclesRetraceVert/10)-1),Int((iCompteurBouclesRetraceHoriz-21)/10)])=0 Then
				' Cellule vide = cellule noire
				SetColor 0,0,0
			Else
				' Cellule occupée = cellule bleue
				SetColor 9,62,253
			End If
			DrawRect iCompteurBouclesRetraceVert,iCompteurBouclesRetraceHoriz,9,9
		Next
	Next
	WriteStdout("      <REFRESHCELLS OUT>      ")
End Function

Function traceTableau()
	WriteStdout("      <TRACETABLEAU IN>      ")
	Local iCompteurBouclesTraceHoriz:Int=0
	Local iCompteurBouclesTraceVert:Int=0
	SetColor 20,112,10
	' Tracage du tableau
	' Lignes horizontales
	For iCompteurBouclesTraceHoriz=20 To 260 Step 10
		DrawLine 10,iCompteurBouclesTraceHoriz,580,iCompteurBouclesTraceHoriz
		' DrawLine 10,iCompteurBouclesTraceHoriz,580,iCompteurBouclesTraceHoriz,1
	Next
	
	' Lignes verticales
	For iCompteurBouclesTraceVert=10 To 580 Step 10
		DrawLine iCompteurBouclesTraceVert,20,iCompteurBouclesTraceVert,260
		' DrawLine iCompteurBouclesTraceVert,20,iCompteurBouclesTraceVert,260,1
	Next
	WriteStdout("      <TRACETABLEAU OUT>      ")
End Function

Function afficherTexte(szTexteAAfficher:String, szCouleur:String, iOmbrage:Int, iPosX:Int, iPosY:Int)
	' WriteStdout(">afficherTexte : IN<")
	' Penser a faire un Flip pour que le texte apparaisse effectivement a l'ecran
	' szCouleur : noir=0 / blanc=255
	' Si iOmbrage est a 0, alors pas d'ombre sous le texte
	Local iCouleurTexte:Int=0
	Local iAncienRouge:Int=0
	Local iAncienVert:Int=0
	Local iAncienBleu:Int=0
	GetColor(iAncienRouge,iAncienVert,iAncienBleu)
	If szCouleur="blanc" Then
		iCouleurTexte=255
	Else
		iCouleurTexte=0
	EndIf
	' Si pas d' ombre
	If iOmbrage=0 Then
		SetColor iCouleurTexte,iCouleurTexte,iCouleurTexte
		DrawText(szTexteAAfficher,iPosX,iPosY)
	' Si ombre
	Else
		' Si le texte est noir
		If iCouleurTexte=0 Then
			' Ombre blanche
			SetColor 255,255,255
			DrawText(szTexteAAfficher,iPosX+1,iPosY+1)
			SetColor 0,0,0
			DrawText(szTexteAAfficher,iPosX,iPosY)
		' Si le texte est blanc
		Else
			' Ombre noire
			SetColor 0,0,0
			DrawText(szTexteAAfficher,iPosX+1,iPosY+1)
			SetColor 255,255,255
			DrawText(szTexteAAfficher,iPosX,iPosY)
		EndIf
	EndIf
	SetColor(iAncienRouge,iAncienVert,iAncienBleu)
	' WriteStdout(">afficherTexte : OUT<")
End Function

