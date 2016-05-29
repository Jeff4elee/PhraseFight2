part of server;

class Phrases {
  static Phrase getPhrase(int index) {
    String text = _phrases[index].trim();
    int points = text.split('.').length;

    return new Phrase(text, points);
  }

  static final List<String> _phrases = '''I once tried to eat a rock.

Ain’t nobody got time for this.

It’s simple, if it jiggles, it’s fat.

Racecar backwards is racecaR.

Try to be a rainbow in someone’s cloud.

You may not think it be like it is, but it do.

These are not the droids you’re looking for.

*Supercalifragilisticexpialidocious.

I never said most of the things I said.

If two wrongs don’t make a right, try three.

I can resist everything except temptation.

My fake plants died because I did not pretend to water them.

Laugh and the world laughs with you, snore and you sleep alone.

Drawing on my fine command of the English language, I said nothing.

A woman’s mind is cleaner than a man’s: she changes it more often.

Alright everybody, line up alphabetically according to height.

I may be drunk, Miss, but in the morning I will be sober and you will still be ugly.

I can't change the direction of the wind, but I can adjust my sails to always reach my destination

Everyone sleeps differently. For example, I sleep on my side, my friend sleeps on his back, and my ex sleeps around.

What concert costs only 45 cents? 50 cent featuring Nickelback.

My friend David had his ID stolen, so now we just call him Dav.

Nineteen and twenty had a fight. 21.

In my view, the Jedi are evil. Well then you are lost

Billy trips over a blue, leather couch before reaching his crunchy chocolate bar. Then, he gets up and finally holds on to the delicious chocolate. He then eats it.

You hear about pluto? That’s messed up.

what if one day you woke up and your nipples were gone

Well my first gay experience goes like this: I stepped on a Corn Flake; now i’m a Cereal Killer

Llama poop is sellable.

If you fart consistently for six years and nine months, enough gas is produced to create the energy of an atomic bomb.

Another one.

Atheism is a non-prophet organization.

Don’t hold your farts in, because they’ll travel up to your brain and that’s where all the crappy ideas come from.

If Mary had baby Jesus, and baby Jesus was the Lamb of God… Did Mary have a little lamb?

If no one comes from the future to stop you from doing it then how bad of a decision can it be?

Anything you say can and will be held against you so only say my name.

The five most reassuring words you can hear: “I haven’t started yet either.”

Boom clap the sound of my thighs this pizzas so good nom nom nom nom nom nom

Gus, don't be an incorrigible Eskimo pie with a caramel ribbon.

The dot used in lowercase "i" and "j" is called a tittle.

I hate when old people poke you at a wedding and say "you're next". So next time I was at a funeral I poked them and said "you're next".

Bikinis and tampons were invented by men.

The worst time to have a heart attack is during a game of charades.

When I die, I want to go peacefully like my grandfather did -- in his sleep. Not yelling and screaming like the passengers in his car.

The scientific theory I like best is that the rings of Saturn are composed entirely of lost airline luggage.

I love deadlines. I like the whooshing sound they make as they fly by.

The only mystery in life is why the kamikaze pilots wore helmets.

The people who make lyric videos on youtube are the backbone of this nation.

Sometimes I look at people and wonder how they’ve made it this far.'''
      .split('\n\n');
}
