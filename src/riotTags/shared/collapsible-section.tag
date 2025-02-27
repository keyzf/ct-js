//
    A small block that displays a section with an h3 header that can be collapsed.
    Supports .aPanel modifier (CSS class), but also works by itself

    @slot
        The insides of the collapsible section.
    @slot header
        A custom header shown next to the one set with the `heading` attribute.
        Can be used with the default one or alone. The markup is placed in a flexrow
        as is.

    @attribute [heading] (string)
        The heading to display
    @attribute [hlevel] (integer)
        A heading level from 1 to 7. Can be empty; if it is, a regular h3 is shown.
    @attribute [icon] (string)
        An icon that will be displayed instead of the default chevron.
    @attribute [defaultstate] ("opened"|"closed")
        Sets the default state of the section. If it is not set, the section will appear closed.
    @attribute [storestatekey] (string)
        If set, remembers the state of this section in localStorage under the specified key.
    @attribute [preservedom] (atomic)
        Whether or not to hide the content instead of removing it from DOM. It is recommended
        to turn this on for larger layouts.

    @attribute [ontoggle] (riot function)
        A callback that triggers when a user folds/unfolds the section. Passes the new state
        and this tag as two arguments.

collapsible-section(class="{opts.class} {opened ? 'opened' : 'closed'}")
    .collapsible-section-aHeader(onclick="{toggle}")
        span
            h1(if="{opts.heading && opts.hlevel == 1}") {opts.heading}
            h2(if="{opts.heading && opts.hlevel == 2}") {opts.heading}
            h3(if="{opts.heading && (opts.hlevel == 3 || !opts.hlevel)}") {opts.heading}
            h4(if="{opts.heading && opts.hlevel == 4}") {opts.heading}
            h5(if="{opts.heading && opts.hlevel == 5}") {opts.heading}
            h6(if="{opts.heading && opts.hlevel == 6}") {opts.heading}
            h7(if="{opts.heading && opts.hlevel == 7}") {opts.heading}
            yield(from="header")
        svg.feather.a(class="{rotated: this.opened}")
            use(xlink:href="#{opts.icon ? opts.icon : 'chevron-up'}")
    .collapsible-section-aWrapper(if="{opened || opts.preservedom}" hide="{!opened && opts.preservedom}")
        <yield/>
    script.
        if (this.opts.storestatekey) {
            this.opened = (localStorage['collapsible-section::' + this.opts.storestatekey] ||
                this.opts.defaultstate) === 'opened';
        } else {
            this.opened = this.opts.defaultstate === 'opened';
        }
        this.toggle = () => {
            this.opened = !this.opened;
            if (this.opts.storestatekey) {
                localStorage['collapsible-section::' + this.opts.storestatekey] = this.opened ? 'opened' : 'closed';
            }
            if (this.opts.ontoggle) {
                this.opts.ontoggle(this.opened, this);
            }
        };
