/**
 * Generateur du rapport BI en Word (.docx)
 * Usage :
 *   node generate_rapport.js
 * Genere : rapport_BI.docx
 */

const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  AlignmentType, BorderStyle, WidthType, ShadingType, HeadingLevel,
  LevelFormat,
} = require('docx');

// ============================================================
// Couleurs et constantes
// ============================================================
const NAVY = '1A2547';
const BLUE_HEADER = '2C3E5E';
const BLUE_LIGHT = 'EEF3FC';
const GREY_LIGHT = 'F5F7FB';
const BORDER_GREY = 'D4DAE5';
const ACCENT_BLUE = '3B7CC7';

const CONTENT_WIDTH = 9026; // A4 content width avec marges 1.5cm

// ============================================================
// Helpers
// ============================================================

const cellBorder = {
  top:    { style: BorderStyle.SINGLE, size: 4, color: BORDER_GREY },
  bottom: { style: BorderStyle.SINGLE, size: 4, color: BORDER_GREY },
  left:   { style: BorderStyle.SINGLE, size: 4, color: BORDER_GREY },
  right:  { style: BorderStyle.SINGLE, size: 4, color: BORDER_GREY },
};

function textRun(text, opts = {}) {
  return new TextRun({
    text,
    font: 'Calibri',
    size: opts.size || 20, // half-points, 20 = 10pt
    bold: opts.bold || false,
    italics: opts.italics || false,
    color: opts.color || '333333',
  });
}

function mixedRuns(segments) {
  // segments: [{text, bold?, italics?, color?, size?}, ...]
  return segments.map(s => textRun(s.text, s));
}

function para(runs, opts = {}) {
  return new Paragraph({
    children: Array.isArray(runs) ? runs : [runs],
    alignment: opts.alignment,
    spacing: opts.spacing || { after: 80 },
  });
}

function simpleCell(text, opts = {}) {
  const width = opts.width;
  return new TableCell({
    borders: cellBorder,
    width: width ? { size: width, type: WidthType.DXA } : undefined,
    shading: opts.fill ? { fill: opts.fill, type: ShadingType.CLEAR, color: 'auto' } : undefined,
    margins: { top: 100, bottom: 100, left: 140, right: 140 },
    children: [para(mixedRuns(Array.isArray(opts.segments) ? opts.segments : [{
      text,
      bold: opts.bold,
      color: opts.color || '333333',
      size: opts.size || 19,
    }]), { spacing: { after: 0 } })],
  });
}

function headerCell(text, width) {
  return new TableCell({
    borders: cellBorder,
    width: { size: width, type: WidthType.DXA },
    shading: { fill: BLUE_HEADER, type: ShadingType.CLEAR, color: 'auto' },
    margins: { top: 120, bottom: 120, left: 140, right: 140 },
    children: [para(textRun(text, { bold: true, color: 'FFFFFF', size: 19 }), { spacing: { after: 0 } })],
  });
}

// Table cle/valeur (2 colonnes, en-tete gris clair a gauche)
function kvTable(rows, labelWidth = 2500) {
  const valueWidth = CONTENT_WIDTH - labelWidth;
  return new Table({
    width: { size: CONTENT_WIDTH, type: WidthType.DXA },
    columnWidths: [labelWidth, valueWidth],
    rows: rows.map(([label, value]) =>
      new TableRow({
        children: [
          simpleCell(label, { width: labelWidth, fill: GREY_LIGHT, bold: true, color: NAVY }),
          simpleCell(value, { width: valueWidth }),
        ],
      })
    ),
  });
}

// Table stylee avec header bleu fonce
function styledTable(headers, rows) {
  const nCols = headers.length;
  const colWidth = Math.floor(CONTENT_WIDTH / nCols);
  const widths = Array(nCols).fill(colWidth);
  // Ajustement pour somme exacte
  widths[nCols - 1] = CONTENT_WIDTH - colWidth * (nCols - 1);

  return new Table({
    width: { size: CONTENT_WIDTH, type: WidthType.DXA },
    columnWidths: widths,
    rows: [
      new TableRow({
        tableHeader: true,
        children: headers.map((h, i) => headerCell(h, widths[i])),
      }),
      ...rows.map(row =>
        new TableRow({
          children: row.map((cell, i) => {
            if (i === 0) {
              return simpleCell(cell, { width: widths[i], fill: BLUE_LIGHT, bold: true, color: NAVY });
            }
            return simpleCell(cell, { width: widths[i] });
          }),
        })
      ),
    ],
  });
}

function sectionTitle(num, text) {
  return new Paragraph({
    spacing: { before: 240, after: 120 },
    children: [
      new TextRun({ text: `${num}. `, bold: true, color: NAVY, size: 24, font: 'Calibri' }),
      new TextRun({ text, bold: true, color: NAVY, size: 24, font: 'Calibri' }),
    ],
  });
}

function bulletPara(runs) {
  return new Paragraph({
    numbering: { reference: 'bullets', level: 0 },
    spacing: { after: 60 },
    children: Array.isArray(runs) ? runs : [runs],
  });
}

function numberedPara(runs) {
  return new Paragraph({
    numbering: { reference: 'numbers', level: 0 },
    spacing: { after: 60 },
    children: Array.isArray(runs) ? runs : [runs],
  });
}

// ============================================================
// Contenu
// ============================================================

const contexte = [
  ['Entreprise', "Rectorat de l'Académie de Rennes"],
  ['Taille', '~1 200 agents (administration rectorale)'],
  ['Portée', "Régionale — 4 départements bretons (Côtes-d'Armor, Finistère, Ille-et-Vilaine, Morbihan)"],
  ['Business model', "Financement public — Ministère de l'Éducation Nationale et Région Bretagne"],
];

const businessProcess = [
  "Collecte des données élèves (résultats, assiduité, contexte socio-économique)",
  "Analyse des performances par établissement et par profil d'élève",
  "Identification des facteurs d'échec",
  "Allocation des moyens d'accompagnement (tutorat, ressources pédagogiques)",
  "Suivi et évaluation de l'impact des actions engagées",
];

const perspectives = [
  ['Résultats', 'Les élèves réussissent-ils ? (scores aux examens)'],
  ['Facteurs élève', 'Quels comportements influencent la réussite ? (étude, sommeil, assiduité, motivation)'],
  ['Facteurs socio-économiques', 'Quel est l\u2019impact du contexte familial ? (revenu, éducation parentale, implication)'],
  ['Facteurs établissement', 'L\u2019environnement scolaire joue-t-il un rôle ? (qualité enseignant, type d\u2019école, ressources)'],
];

const roles = [
  ['Recteur / Directeur académique', 'Rectorat', 'Vue stratégique : vision globale, comparaison départements et types d\u2019écoles'],
  ['Inspecteur d\u2019académie', 'Inspection départementale', 'Vue diagnostic : analyse des inégalités et facteurs socio-économiques'],
  ['Chef d\u2019établissement', 'Lycée / Collège', 'Vue opérationnelle : performance locale, leviers d\u2019action'],
  ['Service Statistique Académique', 'Rectorat', 'Alimentation et fiabilisation des données, maintenance du dispositif BI'],
];

const objectifsBI = [
  ['Dresser un ', true, 'état des lieux', ' de la performance scolaire dans l\u2019académie'],
  ['Identifier les ', true, 'facteurs les plus influents', ' sur la réussite et l\u2019échec'],
  ['Comparer les performances entre ', true, 'écoles publiques et privées', ''],
  ['Détecter les ', true, 'inégalités', ' liées au contexte socio-économique'],
  ['Orienter les ', true, 'décisions d\u2019allocation de ressources', ' (tutorat, accompagnement)'],
];

const kpis = [
  ['Score moyen aux examens', 'Moyenne', 'Exam_Score', '> 70'],
  ['Taux de réussite', '% d\u2019élèves avec score ≥ 67 (seuil ajustable)', 'Exam_Score', '> 60 %'],
  ['Taux d\u2019élèves en difficulté', '% d\u2019élèves avec score < 65 (seuil ajustable)', 'Exam_Score', '< 15 %'],
  ['Taux d\u2019assiduité moyen', 'Moyenne', 'Attendance', '> 85 %'],
  ['Heures d\u2019étude moyennes', 'Moyenne', 'Hours_Studied', '> 20 h'],
  ['Taux d\u2019accès au tutorat', '% d\u2019élèves avec ≥ 1 session', 'Tutoring_Sessions', '> 80 %'],
];

const facteurs = [
  ['Comportement élève', 'Heures d\u2019étude, assiduité, sommeil, activités extrascolaires, motivation, activité physique'],
  ['Contexte familial', 'Revenu familial, implication parentale, niveau d\u2019éducation des parents'],
  ['Environnement scolaire', 'Qualité des enseignants, type d\u2019école, accès aux ressources, influence des pairs'],
  ['Accessibilité & profil', 'Accès internet, distance domicile-école, sessions de tutorat, troubles d\u2019apprentissage, genre, scores précédents'],
];

const objectifsAnalytiques = [
  ['Descriptif', 'Quel est l\u2019état actuel de la performance scolaire ? Quels sont les profils types d\u2019élèves ?'],
  ['Diagnostic', 'Pourquoi certains élèves échouent ? Quels facteurs pèsent le plus ? Quelles inégalités existent ?'],
  ['Comparatif', 'Les performances diffèrent-elles selon le type d\u2019école, le revenu familial, le genre ou l\u2019accès aux ressources ?'],
  ['Prescriptif', 'Quels leviers prioritaires activer pour les élèves en difficulté ? Quelle allocation des ressources maximise l\u2019impact ?'],
];

const source = [
  ['Nom', 'Student Performance Factors'],
  ['Source', 'Kaggle (open source)'],
  ['Lien', 'kaggle.com/datasets/ayeshasiddiqa123/student-perfirmance'],
  ['Volume', '6 607 observations, 20 variables'],
  ['Format', 'CSV'],
];

// ============================================================
// Assemblage
// ============================================================

const children = [];

// --- Header : titre + sous-titre ---
children.push(
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { after: 60 },
    children: [new TextRun({
      text: 'Projet BI — Pilotage de la Réussite Scolaire',
      bold: true, size: 36, color: NAVY, font: 'Calibri',
    })],
  }),
  new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { after: 120 },
    children: [new TextRun({
      text: 'Rectorat de l\u2019Académie de Rennes',
      size: 24, color: ACCENT_BLUE, font: 'Calibri',
    })],
  }),
  // Ligne de separation via paragraphe avec bordure basse
  new Paragraph({
    spacing: { after: 240 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 12, color: NAVY, space: 4 } },
    children: [new TextRun('')],
  })
);

// --- 1. Contexte ---
children.push(sectionTitle(1, 'Contexte et présentation'));
children.push(kvTable(contexte));
children.push(new Paragraph({
  spacing: { before: 120, after: 120 },
  border: { left: { style: BorderStyle.SINGLE, size: 18, color: ACCENT_BLUE, space: 8 } },
  shading: { type: ShadingType.CLEAR, fill: GREY_LIGHT, color: 'auto' },
  children: [
    new TextRun({ text: 'Environnement : ', bold: true, color: NAVY, font: 'Calibri', size: 20 }),
    new TextRun({
      text: 'L\u2019Académie de Rennes évolue dans un contexte marqué par une forte mixité entre établissements publics et privés, des disparités socio-économiques entre territoires et des écarts d\u2019accessibilité liés à la distance domicile-école. La lutte contre le décrochage scolaire et la réduction des inégalités sont au cœur des priorités nationales.',
      font: 'Calibri', size: 20, color: '333333',
    }),
  ],
}));

// --- 2. Scénario ---
children.push(sectionTitle(2, 'Scénario BI envisagé'));
children.push(new Paragraph({
  spacing: { after: 120 },
  children: [
    new TextRun({ text: 'Le Rectorat souhaite déployer un ', font: 'Calibri', size: 20 }),
    new TextRun({ text: 'tableau de bord décisionnel', bold: true, font: 'Calibri', size: 20 }),
    new TextRun({
      text: ' pour analyser les facteurs qui influencent la réussite scolaire des élèves de l\u2019académie. L\u2019objectif est de mieux cibler les dispositifs d\u2019accompagnement (tutorat, ressources, soutien parental) en identifiant les profils d\u2019élèves les plus à risque d\u2019échec. ',
      font: 'Calibri', size: 20,
    }),
    new TextRun({
      text: 'L\u2019ambition est de réduire de 5 points le taux d\u2019élèves en difficulté et de résorber les inégalités scolaires sur un horizon de 3 ans.',
      font: 'Calibri', size: 20, bold: true,
    }),
  ],
}));

// --- 3. Business process ---
children.push(sectionTitle(3, 'Business process'));
children.push(new Paragraph({
  spacing: { after: 60 },
  children: [
    new TextRun({ text: 'Le processus métier concerné est le ', font: 'Calibri', size: 20 }),
    new TextRun({ text: 'pilotage de la réussite scolaire', bold: true, font: 'Calibri', size: 20 }),
    new TextRun({ text: ' :', font: 'Calibri', size: 20 }),
  ],
}));
businessProcess.forEach(t => children.push(numberedPara(textRun(t))));

// --- 4. Perspectives ---
children.push(sectionTitle(4, 'Perspectives'));
children.push(new Paragraph({
  spacing: { after: 60 },
  children: [textRun('Le projet BI s\u2019articule autour de 4 perspectives :')],
}));
children.push(styledTable(['Perspective', 'Question clé'], perspectives));

// --- 5. Roles, instances et vues ---
children.push(sectionTitle(5, 'Rôles, instances et vues'));
children.push(styledTable(['Rôle', 'Instance', 'Vue'], roles));

// --- 6. Objectifs d'analyse BI ---
children.push(sectionTitle(6, 'Objectifs d\u2019analyse BI'));
objectifsBI.forEach(([pre, isBold, boldText, post]) => {
  const runs = [textRun(pre)];
  if (boldText) runs.push(textRun(boldText, { bold: true, color: NAVY }));
  if (post) runs.push(textRun(post));
  children.push(bulletPara(runs));
});

// --- 7. KPIs ---
children.push(sectionTitle(7, 'KPI(s)'));
children.push(new Paragraph({
  spacing: { after: 60 },
  children: [textRun('Ces objectifs d\u2019analyse s\u2019appuient sur les indicateurs clés de performance (KPIs) suivants, permettant de mesurer l\u2019atteinte des ambitions du Rectorat :')],
}));
children.push(styledTable(['KPI', 'Mesure', 'Variable source', 'Cible'], kpis));
children.push(new Paragraph({
  spacing: { before: 80, after: 120 },
  children: [
    new TextRun({
      text: 'Les seuils de réussite et de difficulté sont paramétrables directement dans le tableau de bord. Les cibles indiquées sont à définir par le Rectorat selon ses priorités stratégiques.',
      italics: true, color: '5D6D7E', font: 'Calibri', size: 18,
    }),
  ],
}));

// --- 8. Facteurs influents ---
children.push(sectionTitle(8, 'Facteurs influents'));
children.push(new Paragraph({
  spacing: { after: 60 },
  children: [textRun('Pour expliquer les variations observées sur ces KPIs, l\u2019analyse s\u2019appuie sur un ensemble de facteurs influents. Les 19 variables retenues sont regroupées en 4 catégories :')],
}));
children.push(styledTable(['Catégorie', 'Facteurs'], facteurs));

// --- 9. Objectifs analytiques ---
children.push(sectionTitle(9, 'Objectifs analytiques'));
children.push(new Paragraph({
  spacing: { after: 60 },
  children: [textRun('L\u2019exploitation de ces facteurs est structurée autour de quatre niveaux d\u2019analyse complémentaires :')],
}));
children.push(styledTable(['Type', 'Objectif'], objectifsAnalytiques));

// --- 10. Source de donnees ---
children.push(sectionTitle(10, 'Source de données'));
children.push(kvTable(source));

// ============================================================
// Document
// ============================================================

const doc = new Document({
  creator: 'Desjardins Bryan & Festoc Julianne',
  title: 'Projet BI — Pilotage de la Réussite Scolaire',
  description: 'Rapport BI - Rectorat de l\u2019Académie de Rennes',
  styles: {
    default: { document: { run: { font: 'Calibri', size: 20 } } },
  },
  numbering: {
    config: [
      {
        reference: 'bullets',
        levels: [{
          level: 0,
          format: LevelFormat.BULLET,
          text: '\u2022',
          alignment: AlignmentType.LEFT,
          style: { paragraph: { indent: { left: 720, hanging: 360 } } },
        }],
      },
      {
        reference: 'numbers',
        levels: [{
          level: 0,
          format: LevelFormat.DECIMAL,
          text: '%1.',
          alignment: AlignmentType.LEFT,
          style: { paragraph: { indent: { left: 720, hanging: 360 } } },
        }],
      },
    ],
  },
  sections: [{
    properties: {
      page: {
        size: { width: 11906, height: 16838 }, // A4
        margin: { top: 850, right: 1000, bottom: 850, left: 1000 }, // ~1.5cm
      },
    },
    children,
  }],
});

Packer.toBuffer(doc).then(buffer => {
  const output = path.join(__dirname, 'rapport_BI.docx');
  fs.writeFileSync(output, buffer);
  console.log(`Rapport genere : ${output}`);
});
