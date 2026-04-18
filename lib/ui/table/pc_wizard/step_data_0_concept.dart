import 'package:flutter/material.dart';

import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataConcept extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataConcept()
    : super(title: 'Concept', canSkip: true, clearNextOnChange: false);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? concept;
  String? general;
  String? appearance;
  String? family;
  String? past;
  String? mentality;
  String? interests;
  String? passions;
  String? hate;
  String? ambitions;

  @override
  Widget overviewWidget(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Concept : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: concept == null || concept!.isEmpty ? "Aucun" : concept,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Profil général : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: general == null || general!.isEmpty ? "Aucun" : general,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Physique : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: appearance == null || appearance!.isEmpty ? "Aucun" : appearance,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Famille : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: family == null || family!.isEmpty ? "Aucune" : family,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Passé : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: past == null || past!.isEmpty ? "Aucun" : past,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Mentalité : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: mentality == null || mentality!.isEmpty ? "Aucune" : mentality,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Intérêts : ",
                style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: interests == null || interests!.isEmpty ? "Aucuns" : interests,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Passions : ",
                style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: passions == null || passions!.isEmpty ? "Aucunes" : passions,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Haines : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: hate == null || hate!.isEmpty ? "Aucunes" : hate,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Ambitions : ",
                style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ambitions == null || ambitions!.isEmpty ? "Aucunes" : ambitions,
                style: theme.textTheme.bodyMedium
              ),
            ]
          )
        ),
      ],
    );
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    return [sliverWrap([Form(
      key: formKey,
      child: Column(
        spacing: 12.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Avant de parler de chiffres et de termes techniques, il est important de définir le type de personnage que vous souhaitez créer. Demandez-vous simplement quel âge aura votre personnage, de quel style de dragon il se rapprochera, quels seront ses principaux centres d'intérêt, vers quel métier il va se tourner, etc. À ce stade, une simple phrase suffit : un jeune guerrier au tempérament imprévisible poursuivant un ennemi ancestral aux quatre coins du royaume, un vieil herboriste au passé tourmenté, un montreur d'animaux quelque peu malhomnête, une danseuse itinérante avide de découvrir le monde, etc.\nCette seule idée de départ vous permettra de simplifier les choix à venir et d’attribuer les bonnes valeurs aux différentes caractéristiques de votre personnage."
          ),
          TextFormField(
            initialValue: concept,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Concept'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != concept;
            },
            onSaved: (String? v) {
              concept = v;
            },
          ),
          Divider(),
          Text(
            "Le profil général : le personnage est-il un homme ou une femme ? Est-ce un enfant, un adulte ou un vieillard ? Est-il plutôt “physique”, intellectuel ou manuel ? Préfère-t-il le combat, la magie, la connaissance, le voyage, le dialogue, les rencontres ? Vers quelle caste va-t-il se tourner ?"
          ),
          TextFormField(
            initialValue: general,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Profil général'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != general;
            },
            onSaved: (String? v) {
              general = v;
            },
          ),
          Divider(),
          Text(
            "Le physique : le personnage est-il plus grand ou plus petit que la moyenne ? Est-il maigre, athlétique, particulièrement musclé ou légèrement enrobé ? De quelle couleur sont ses cheveux, ses yeux ? A-t-il un signe distinctif, une cicatrice, un trait physique particulier ?"
          ),
          TextFormField(
            initialValue: appearance,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Physique'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != appearance;
            },
            onSaved: (String? v) {
              appearance = v;
            },
          ),
          Divider(),
          Text(
            "La famille : de quelle famille le personnage est-il issu ? Est-il noble, orphelin, d’origine paysanne, issu d’une caste quelconque ? A-t-il des frères, des sœurs, un jumeau, des enfants ? Ses parents ou grands-parents sont-ils toujours en vie ?"
          ),
          TextFormField(
            initialValue: family,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Famille'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != family;
            },
            onSaved: (String? v) {
              family = v;
            },
          ),
          Divider(),
          Text(
            "Le passé : le personnage a-t-il déjà vécu des événements importants ? A-t-il participé à des batailles, à des cérémonies ? Un acte remarquable lui est-il attribué ? A-t-il commis une faute, une erreur, un meurtre ? S’est-il attiré les foudres d’un ennemi puissant, la sympathie d’un compagnon sincère, la complicité d’un animal familier ? De quel genre de contrée vient-il ? A-t-il été obligé de quitter sa ville ou sa région natale et, dans ce cas, pour quelles raisons ? Est-il recherché ou connu, anonyme, banni ?"
          ),
          TextFormField(
            initialValue: past,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Passé'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != past;
            },
            onSaved: (String? v) {
              past = v;
            },
          ),
          Divider(),
          Text(
            "La mentalité : le personnage suit-il un code de conduite, des principes moraux, les édits d’un culte ? A-t-il le sens de l’honneur, de la loyauté, du courage ? Quels sont ses vices, ses vertus, ses qualités, ses défauts ? Que pense-t-il de la magie, des dragons, des hommes, du combat ? Est-il effrayé par la magie ou la technologie ?"
          ),
          TextFormField(
            initialValue: mentality,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Mentalité'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != mentality;
            },
            onSaved: (String? v) {
              mentality = v;
            },
          ),
          Divider(),
          Text(
            "Les centres d’intérêt : quels sont les principaux intérêts du personnage ? Qu’est-ce qui le pousse à voyager, à se battre, à pratiquer la magie, à vendre ses services ? A-t-il un idéal, une quête à mener, une envie secrète ? Rêve-t-il d’une vengeance, d’une découverte, d’une rencontre ? Est-il motivé par la perspective du gain, de la connaissance, de l’apprentissage ? Pourquoi a-t-il choisi sa caste ?"
          ),
          TextFormField(
            initialValue: interests,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Intérêts'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != interests;
            },
            onSaved: (String? v) {
              interests = v;
            },
          ),
          Divider(),
          Text(
            "Les passions : le personnage est-il attiré par l’argent, l’amour, le danger, la violence, l’envie d’aider son prochain ? A-t-il un être cher à son cœur, une femme, un mari, un foyer ? Exerce-t-il son métier pour parvenir à un but précis ? A-t-il un objet, un livre, une arme de prédilection ?"
          ),
          TextFormField(
            initialValue: passions,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Passions'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != passions;
            },
            onSaved: (String? v) {
              passions = v;
            },
          ),
          Divider(),
          Text(
            "Les haines : le personnage poursuit-il un ennemi, une vengeance ? En veut-il à quelqu’un de précis, à un groupe, à une communauté ? A-t-il des préjugés à l’égard d’une tribu, d’une nation, d’une famille de dragons ou de créatures ?"
          ),
          TextFormField(
            initialValue: hate,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Haines'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != hate;
            },
            onSaved: (String? v) {
              hate = v;
            },
          ),
          Divider(),
          Text(
            "Les ambitions : quelles sont les ambitions du personnage ? S’est-il fixé un but, un objectif ? Que souhaite-t-il accomplir ? Qu'attend-il de ses voyages, de ses aventures ? Souhaite-t-il faire des rencontres particulières, amasser de l’or, découvrir une région ?"
          ),
          TextFormField(
            initialValue: ambitions,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Ambitions'),
            ),
            maxLines: null,
            onChanged: (String? v) {
              changed = changed || v != ambitions;
            },
            onSaved: (String? v) {
              ambitions = v;
            },
          ),
        ],
      ),
    )])];
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) => formKey.currentState!.validate();

  @override
  void init(PlayerCharacterWizardModel model) {
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    model.concept = concept = null;
    model.general = general = null;
    model.appearance = appearance = null;
    model.family = family = null;
    model.past = past = null;
    model.mentality = mentality = null;
    model.interests = interests = null;
    model.passions = passions = null;
    model.hate = hate = null;
    model.ambitions = ambitions = null;
  }
  
  @override
  void clear() {
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    formKey.currentState!.save();

    model.concept = concept;
    model.general = general;
    model.appearance = appearance;
    model.family = family;
    model.past = past;
    model.mentality = mentality;
    model.interests = interests;
    model.passions = passions;
    model.hate = hate;
    model.ambitions = ambitions;
  }
}