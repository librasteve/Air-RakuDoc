use RakuDoc::Render;
use RakuDoc::To::HTML;
use Air;
use Air::Component;

sub internal-rakudoc( $source ) is export {
    state RakuDoc::To::HTML $rend-obj .= new;
    $rend-obj.render( $source.AST )
}

role RakuDoc    does Component {
    #| rakudoc source to be converted
    has Str $.rakudoc;
    # cache the result
    has Str $!result;

    #| .new positional takes Str $code
    multi method new(Str $rakudoc, *%h) {
        self.bless: :$rakudoc, |%h;
    }

    multi method HTML {
        $!result = internal-rakudoc($!rakudoc) unless $!result;
        $!result
    }
}