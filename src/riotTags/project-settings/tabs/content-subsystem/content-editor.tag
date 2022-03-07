content-editor
    h1 {contentType.readableName || contentType.name || voc.missingTypeName}
    extensions-editor(customextends="{extends}" wide="true" entity="{contentType}")
    script.
        this.contentType = this.opts.contenttype;
        this.namespace = 'settings.content';
        this.mixin(window.riotVoc);

        this.makeExtends = () => {
            this.extends = [{
                name: this.voc.entries,
                key: 'entries',
                type: 'table',
                fields: this.contentType.specification.map(spec => {
                    const field = {
                        key: spec.name || spec.readableName,
                        name: spec.readableName || spec.name,
                        type: spec.array ? 'array' : (spec.type || 'text'),
                        arrayType: spec.type || 'text',
                        required: spec.required
                    };
                    if (field.type === 'array') {
                        field.default = () => [];
                    } else if (field.type === 'sliderAndNumber') {
                        field.min = 0;
                        field.max = 100;
                        field.step = 1;
                    } else if (field.type === 'texture' || field.type === 'template') {
                        field.default = -1;
                    } else if (field.type === 'number' || field.type === 'sliderAndNumber') {
                        field.default = 0;
                    }
                    return field;
                })
            }];
        };
        this.makeExtends();

        this.on('update', () => {
            if (this.contentType !== this.opts.contenttype) {
                this.contentType = this.opts.contenttype;
                this.makeExtends();
            }
        });
